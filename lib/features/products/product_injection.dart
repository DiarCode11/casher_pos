import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/features/products/cubit/product_cubit.dart';
import 'package:casher_pos/features/products/data/repositories/product_repository.dart';
import 'package:get_it/get_it.dart';

void productInjection(GetIt g) {
  g.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(databaseHelper: g<DatabaseHelper>()),
  );

  g.registerFactory(() => ProductCubit(repository: g<ProductRepository>()));
}