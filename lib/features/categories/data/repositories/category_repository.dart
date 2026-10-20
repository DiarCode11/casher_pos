import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/features/categories/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getAllCategories();
  Future<void> storeCategory(CategoryModel model);
  Future<void> deleteCategory(int id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final DatabaseHelper databaseHelper;

  CategoryRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final db = await databaseHelper.database;
      final rawCategories = await db.rawQuery(
        'SELECT c.id, c.name, c.created_at, c.deleted_at '
        'FROM categories c '
        'WHERE c.deleted_at IS NULL '
        'ORDER BY c.created_at DESC',
      );

      return rawCategories.map(CategoryModel.fromMap).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> storeCategory(CategoryModel model) async {
    final db = await databaseHelper.database;
    await db.insert("categories", model.toMap());
  }

  @override
  Future<void> deleteCategory(int id) async {
    final db = await databaseHelper.database;
    await db.update(
      "categories",
      {'deleted_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
