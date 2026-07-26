import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/features/sales/data/models/sales_product_model.dart';

abstract class SalesLocalDataSource {
  Future<List<SalesProductModel>> getProducts();
}
class SalesLocalDataSourceImpl implements SalesLocalDataSource {
  final DatabaseHelper databaseHelper;
  SalesLocalDataSourceImpl({required this.databaseHelper});
  
  @override
  Future<List<SalesProductModel>> getProducts() async {
    final db = await databaseHelper.database;

    final rawProducts = await db.rawQuery("SELECT * FROM products WHERE deleted_at IS NULL;");

    List<SalesProductModel> productList = rawProducts.map((item) {
      return SalesProductModel.fromMap(item); 
    }).toList();

    return productList;
  }
}