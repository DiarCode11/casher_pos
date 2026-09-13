import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/features/sales/data/models/sales_product_model.dart';

abstract class SalesRepository {
  Future<List<SalesProductModel>> getProducts();  
}

class SalesRepositoryImpl implements SalesRepository {
  final DatabaseHelper databaseHelper;

  SalesRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<SalesProductModel>> getProducts() async {
    try {
      final db = await databaseHelper.database;
      final rawProducts = await db.rawQuery(
        'SELECT * FROM products WHERE deleted_at IS NULL;',
      );

      return rawProducts.map(SalesProductModel.fromMap).toList();
    } catch (e) {
      throw Exception("Gagal mengambil data");
    }
  }
}