import 'dart:ffi';

import 'package:casher_pos/features/products/cubit/product_state.dart';
import 'package:casher_pos/features/products/data/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductState());

  Future<void> loadProducts() async {
    if (isClosed) return; 
    emit(state.copyWith(status: ProductStatus.loading));

    await Future.delayed(const Duration(seconds: 1));
    final dummyProducts = [
      ProductModel(id: '1', name: 'Indomie', price: 3500, stock: 100, categoryId: 'food'),
      ProductModel(id: '2', name: 'Aqua 600ml', price: 4000, stock: 50, categoryId: 'drink'),
    ];

    emit(state.copyWith(status: ProductStatus.success, products: dummyProducts));
  }

  int getStock(String id) {
    return state.products.where((p) => p.id == id).first.stock;
  }
}