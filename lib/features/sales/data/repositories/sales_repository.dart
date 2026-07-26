import 'package:casher_pos/features/sales/data/datasources/sales_local_datasource.dart';
import 'package:casher_pos/features/sales/data/models/sales_product_model.dart';

abstract class SalesRepository {
  Future<List<SalesProductModel>> getProducts();  
}

class SalesRepositoryImpl implements SalesRepository {
  final SalesLocalDataSource localDataSource;

  SalesRepositoryImpl({required this.localDataSource});

  @override
  Future<List<SalesProductModel>> getProducts() async {
    try {
      return await localDataSource.getProducts();
    } catch (e) {
      throw Exception("Gagal mengambil data");
    }
  }
}