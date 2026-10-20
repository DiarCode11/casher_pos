import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/features/categories/category_injection.dart';
import 'package:casher_pos/features/products/product_injection.dart';
import 'package:casher_pos/features/sales/sales_injection.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Datasource
  salesInjection(getIt);
  productInjection(getIt);
  categoryInjection(getIt);
}