import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/features/sales/data/datasources/sales_local_datasource.dart';
import 'package:casher_pos/features/sales/data/repositories/sales_repository.dart';
import 'package:get_it/get_it.dart';

void salesInjection(GetIt g) {
  g.registerLazySingleton<SalesLocalDataSource>(
    () => SalesLocalDataSourceImpl(databaseHelper: g<DatabaseHelper>()),
  );

  g.registerLazySingleton<SalesRepository>(
    () => SalesRepositoryImpl(localDataSource: g<SalesLocalDataSource>())
  );
}