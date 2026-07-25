import 'package:casher_pos/features/products/cubit/product_state.dart';
import 'package:casher_pos/features/products/data/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesCubit extends Cubit<ProductState> {
  SalesCubit() : super(const ProductState());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));

    await Future.delayed(const Duration(seconds: 1));

    final dummyProducts = [
      ProductModel(id: '1', name: 'Indomie Goreng Special', price: 3500, stock: 100, categoryId: 'food'),
      ProductModel(id: '2', name: 'Aqua Botol 600ml', price: 4000, stock: 85, categoryId: 'drink'),
      ProductModel(id: '3', name: 'Teh Pucuk Harum 350ml', price: 4500, stock: 60, categoryId: 'drink'),
      ProductModel(id: '4', name: 'Sari Roti Tawar', price: 15000, stock: 20, categoryId: 'food'),
      ProductModel(id: '5', name: 'Chitato Sapi Panggang', price: 11000, stock: 45, categoryId: 'snack'),
      ProductModel(id: '6', name: 'Le Minerale 600ml', price: 3500, stock: 120, categoryId: 'drink'),
      ProductModel(id: '7', name: 'Silverqueen 58gr', price: 18500, stock: 30, categoryId: 'snack'),
      ProductModel(id: '8', name: 'Kopi Kenangan Botol', price: 9500, stock: 40, categoryId: 'drink'),
      ProductModel(id: '9', name: 'Beras Premium 5kg', price: 68000, stock: 15, categoryId: 'food'),
      ProductModel(id: '10', name: 'Telur Ayam 1kg', price: 28000, stock: 25, categoryId: 'food'),
    ];

    emit(state.copyWith(status: ProductStatus.success, products: dummyProducts));
  }

  int getStock(String id) => state.products.where((item) => item.id == id).first.stock;
}