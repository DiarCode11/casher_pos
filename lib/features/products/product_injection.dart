import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/features/products/data/datasources/product_local_datasource.dart';
import 'package:casher_pos/features/products/data/repositories/product_repository.dart';
import 'package:get_it/get_it.dart';

void productInjection(GetIt g) {
  g.registerLazySingleton<ProductLocalDatasource>(
    () => ProductLocalDatasourceImpl(databaseHelper: g<DatabaseHelper>())
  );

  g.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(localDatasource: g<ProductLocalDatasource>())
  );
}