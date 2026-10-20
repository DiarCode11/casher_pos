import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/features/categories/cubit/category_cubit.dart';
import 'package:casher_pos/features/categories/data/repositories/category_repository.dart';
import 'package:get_it/get_it.dart';

void categoryInjection(GetIt g) {
  g.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(databaseHelper: g<DatabaseHelper>()),
  );

  g.registerFactory(() => CategoryCubit(repository: g<CategoryRepository>()));
}