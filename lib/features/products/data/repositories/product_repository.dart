import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/features/products/data/dtos/store_product_dto.dart';
import 'package:casher_pos/features/products/data/models/product_model.dart';
import 'package:casher_pos/shared/dtos/response_dto.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getAllProducts();
  Future<void> storeProduct(ProductModel model);
  Future<void> deleteProduct(int id);
  Future<int> checkStock(int id);
  Future<ProductModel> getProductById(int id);
  Future<void> updateProduct(int id, ProductModel model);
}

class ProductRepositoryImpl implements ProductRepository {
  final DatabaseHelper databaseHelper;

  ProductRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final db = await databaseHelper.database;
      final rawProducts = await db.rawQuery(
        'SELECT p.id, p.name, p.image_path, p.price, p.stock, p.created_at '
        'FROM products p '
        'WHERE p.deleted_at IS NULL'
      );

      return rawProducts.map(ProductModel.fromMap).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> storeProduct(ProductModel model) async {
    final db = await databaseHelper.database;
    await db.insert("products", model.toMap());
  }

  @override
  Future<void> deleteProduct(int id) async {
    final db = await databaseHelper.database;
    await db.update("products", 
      {'deleted_at': DateTime.now().toIso8601String()}, 
      where: 'id = ?', 
      whereArgs: [id]);
  }

  @override
  Future<int> checkStock(int id) async {
    final db = await databaseHelper.database;
    final data = await db.rawQuery(
        'SELECT p.stock '
        'FROM products p '
        'WHERE p.deleted_at IS NULL AND p.id = ?',
        [id]
      );

    if (data.isEmpty) return 0;

    return data.first['stock'] as int;
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final db = await databaseHelper.database;
    final data = await db.rawQuery(
        'SELECT * '
        'FROM products p '
        'WHERE p.deleted_at IS NULL AND p.id = ?',
        [id]
      );

    return data.map(ProductModel.fromMap).first;
  }

  @override
  Future<void> updateProduct(int id, ProductModel model) async {
    final db = await databaseHelper.database;
    await db.update("products", 
      model.imagePath != null 
        ? {
          "name": model.name,
          "price": model.price,
          "image_path": model.imagePath
        }
        : {
          "name": model.name,
          "price": model.price,
        }, 
      where: 'id = ?', 
      whereArgs: [id]);
  }
}