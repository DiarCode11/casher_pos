import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/features/sales/sales_injection.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Datasource
  salesInjection(getIt);
}