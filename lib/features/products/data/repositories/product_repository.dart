import 'package:casher_pos/features/products/data/datasources/product_local_datasource.dart';
import 'package:casher_pos/features/products/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getAllProducts();
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDatasource localDatasource;

  ProductRepositoryImpl({required this.localDatasource});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      return await localDatasource.getAllProducts();
    } catch (e) {
      throw Exception(e);
    }
  }
}