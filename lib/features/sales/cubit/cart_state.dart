import 'package:casher_pos/features/sales/data/models/cart_item_model.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  final List<CartItemModel> items;

  const CartState({this.items = const []});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  int get totalPrice => items.fold(0, (sum, item) => sum + item.subtotal);
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }

  List<Map<String, dynamic>> listItem() {
    return items.map((item) => item.toJson()).toList();
  }

  @override
  List<Object?> get props => [items];
}