import 'package:casher_pos/features/sales/cubit/cart_state.dart';
import 'package:casher_pos/features/sales/cubit/sales_cubit.dart';
import 'package:casher_pos/features/sales/data/models/cart_item_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  final SalesCubit salesCubit;
  CartCubit({required this.salesCubit}) : super(const CartState());

  void addItem(CartItemModel newItem) {
    final existingIndex = state.items.indexWhere(
      (item) => item.productId == newItem.productId,
    );

    final currentQty = state.items.where((item) => item.productId == newItem.productId).firstOrNull?.quantity ?? 0;
    final stock = salesCubit.getStock(newItem.productId);

    if (currentQty >= stock) return;

    if (existingIndex != -1 ) {
      // Kalau produk udah ada di cart, tambah quantity-nya aja
      final updatedItems = List<CartItemModel>.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + newItem.quantity,
      );
      emit(state.copyWith(items: updatedItems));

    } else {
      // Produk baru, tambahin ke list
      emit(state.copyWith(items: [...state.items, newItem]));
    }

    print(state.listItem());
  }

  bool isStockLimitReached(int productId) {
    final currentQty = state.items.where((item) => item.productId == productId).firstOrNull?.quantity ?? 0;
    final stock = salesCubit.getStock(productId);

    return currentQty >= stock;
  }

  void increaseQtyItem(int id) {
    final currentItems = List<CartItemModel>.from(state.items);

    final index = currentItems.indexWhere((item) => item.productId == id);

    if (index != -1) {
      final currentItem = currentItems[index];
      final currentQty = currentItem.quantity + 1;
      final stock = salesCubit.getStock(id);

      if (currentQty > stock) return;

      currentItems[index] = currentItem.copyWith(quantity: currentQty);
      emit(CartState(items: currentItems));
    }
  }

  void decreaseQtyItem(int id) {
    final currentItems = List<CartItemModel>.from(state.items);

    final index = currentItems.indexWhere((item) => item.productId == id);

    if (index != -1) {
      final currentItem = currentItems[index];
      if (currentItem.quantity == 1) {
        removeItem(currentItem.productId);
        return;
      }
      final currentQty = currentItem.quantity - 1;

      currentItems[index] = currentItem.copyWith(quantity: currentQty);
      emit(CartState(items: currentItems));
    }

  }

  void removeItem(int productId) {
    final updatedItems = state.items
        .where((item) => item.productId != productId)
        .toList();
    emit(state.copyWith(items: updatedItems));
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    final updatedItems = state.items.map((item) {
      return item.productId == productId
          ? item.copyWith(quantity: quantity)
          : item;
    }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  List<CartItemModel> getCartItem() {
    return state.items;
  }

  int getSubTotal() {
    final int subTotal = state.items.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity));

    return subTotal;
  }

  void clearCart() {
    emit(const CartState());
  }

  
}