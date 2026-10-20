import 'package:casher_pos/core/abstracts/migration.dart';
import 'package:casher_pos/core/database/migrations/m1_add_initial_tables.dart';
import 'package:casher_pos/core/database/migrations/m2_add_categories_table.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  final List<Migration> _migrations = [
    M1AddInitialTables(),
    M2AddCategoriesTable(),
  ];

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('casher_pos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Wajib untuk desktop (Windows/Linux/macOS)
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final appSupportDir = await getApplicationSupportDirectory();
    final path = join(appSupportDir.path, filePath);

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: _migrations.length,
        onCreate: (db, version) async {
          for (var migration in _migrations) {
            await migration.up(db);
          }
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          for (var i = oldVersion; i < newVersion; i++) {
            await _migrations[i].up(db);
          }
        },
      ),
    );
  }
}