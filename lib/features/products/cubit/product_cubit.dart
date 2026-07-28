import 'dart:ffi';

import 'package:casher_pos/features/products/cubit/product_state.dart';
import 'package:casher_pos/features/products/data/models/product_model.dart';
import 'package:casher_pos/features/products/data/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit({required this.repository}) : super(const ProductState());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));
    if (isClosed) return; 

    await Future.delayed(Duration(seconds: 2));
    if (isClosed) return; 

    final products = await repository.getAllProducts();
    if (isClosed) return; 

    emit(state.copyWith(status: ProductStatus.success, products: products));
  }

  int getStock(String id) {
    return state.products.where((p) => p.id == id).first.stock;
  }
}