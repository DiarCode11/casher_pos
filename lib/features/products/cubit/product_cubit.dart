import 'dart:ffi';

import 'package:casher_pos/core/extensions/string_ext.dart';
import 'package:casher_pos/features/products/cubit/product_state.dart';
import 'package:casher_pos/features/products/data/dtos/store_product_dto.dart';
import 'package:casher_pos/features/products/data/dtos/update_product_dto.dart';
import 'package:casher_pos/features/products/data/models/product_model.dart';
import 'package:casher_pos/features/products/data/repositories/product_repository.dart';
import 'package:casher_pos/shared/dtos/response_dto.dart';
import 'package:casher_pos/shared/helpers/image_storage_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit({required this.repository}) : super(const ProductState());

  void _safeEmit(ProductState newState) {
    if (!isClosed) emit(newState);
  }

  Future<ResponseDto<String>> storeProduct(StoreProductDto dto) async {
    try {
      String? imagePath;
      print("Isi image: ${dto.image}");
      if (dto.image != null) {
        imagePath = await ImageStorageHelper.saveImage(
          dto.image!,
          prefix: 'product',
        );
      }

      final product = ProductModel(
        name: dto.name, 
        price: dto.price.toCleanInt(), 
        stock: 0, 
        createdAt: DateTime.now(), 
        imagePath: imagePath
      );
      await repository.storeProduct(product);

      return ResponseDto(success: true, response: "Berhasil menyimpan produk");
    } catch (e) {
      return ResponseDto(success: false, response: e.toString());
    }
  }

  Future<void> loadProducts() async {
    _safeEmit(state.copyWith(status: ProductStatus.loading));

    final products = await repository.getAllProducts();

    _safeEmit(state.copyWith(status: ProductStatus.success, products: products));
  }

  Future<ResponseDto<String>> deleteProduct(int id) async {
    try {
      final stock = await repository.checkStock(id);

      if (stock > 0) {
        return ResponseDto(success: false, response: "Produk tidak dapat dihapus karena masih ada stok");
      }

      await repository.deleteProduct(id);
      return ResponseDto(success: true, response: "Berhasil di hapus");
    } catch (e) {
      return ResponseDto(success: false, response: e.toString());
    }
  }

  Future<ResponseDto<String>> updateProduct(int id, UpdateProductDto dto) async {
    try {
      String? imagePath;
      print("Isi image: ${dto.image}");
      if (dto.image != null) {
        imagePath = await ImageStorageHelper.saveImage(
          dto.image!,
          prefix: 'product',
        );
      }

      final product = ProductModel(
        name: dto.name, 
        price: dto.price.toCleanInt(), 
        stock: 0, 
        createdAt: DateTime.now(), 
        imagePath: imagePath
      );
      
      await repository.updateProduct(dto.id, product);

      return ResponseDto(success: true, response: "Berhasil memperbarui produk");
    } catch (e) {
      return ResponseDto(success: false, response: e.toString());
    }
  }

  int getStock(String id) {
    return state.products.where((p) => p.id == id).first.stock;
  }
}