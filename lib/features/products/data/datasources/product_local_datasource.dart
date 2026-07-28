import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/features/products/data/models/product_model.dart';

abstract class ProductLocalDatasource {
  Future<List<ProductModel>> getAllProducts();
}

class ProductLocalDatasourceImpl implements ProductLocalDatasource {
  final DatabaseHelper databaseHelper;

  ProductLocalDatasourceImpl({required this.databaseHelper});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final db = await databaseHelper.database;
    
    final rawProducts = await db.rawQuery("SELECT p.id, p.name, p.image_path, p.price, p.stock, p.created_at FROM products p");

    final data = rawProducts.map((raw) => ProductModel.fromMap(raw)).toList();
    return data;
  }
}