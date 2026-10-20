import 'package:casher_pos/core/abstracts/migration.dart';
import 'package:sqflite_common/sqlite_api.dart';

class M2AddCategoriesTable extends Migration {
  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL DEFAULT (datetime('now')),
        deleted_at TEXT
      );
    ''');
  }

  @override
  Future<void> down(Database db) {
    // TODO: implement down
    throw UnimplementedError();
  }
}
