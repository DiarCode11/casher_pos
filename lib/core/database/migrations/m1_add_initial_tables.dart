import 'package:casher_pos/core/abstracts/migration.dart';
import 'package:sqflite_common/sqlite_api.dart';

class M1AddInitialTables extends Migration {
  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        image_path TEXT,
        price INTEGER NOT NULL DEFAULT 0 CHECK (price >= 0),
        stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
        created_at TEXT NOT NULL DEFAULT (datetime('now')),
        deleted_at TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL CHECK (type IN ('sales', 'purchase')),
        description TEXT,
        subtotal INTEGER NOT NULL DEFAULT 0 CHECK (subtotal >= 0),
        cash INTEGER NOT NULL DEFAULT 0 CHECK (cash >= 0),
        change INTEGER NOT NULL DEFAULT 0 CHECK (change >= 0),
        created_at TEXT NOT NULL DEFAULT (datetime('now')),
        deleted_at TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE price_histories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        price INTEGER NOT NULL CHECK (price >= 0),
        created_at TEXT NOT NULL DEFAULT (datetime('now')),
        FOREIGN KEY (product_id) REFERENCES products(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE transaction_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        type TEXT NOT NULL CHECK (type IN ('sales', 'purchase')),
        transaction_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL CHECK (quantity >= 0),
        price INTEGER NOT NULL CHECK (price >= 0),
        total_price INTEGER NOT NULL CHECK (total_price >= 0),
        FOREIGN KEY (product_id) REFERENCES products(id),
        FOREIGN KEY (transaction_id) REFERENCES transactions(id)
      );
    ''');
  }

  @override
  Future<void> down(Database db) {
    // TODO: implement down
    throw UnimplementedError();
  }
}