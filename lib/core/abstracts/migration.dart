import 'package:sqflite/sqlite_api.dart';

abstract class Migration {
  Future<void> up(Database db);
  Future<void> down(Database db);
}