import 'package:casher_pos/features/categories/cubit/category_state.dart';
import 'package:casher_pos/features/categories/data/dtos/store_category_dto.dart';
import 'package:casher_pos/features/categories/data/models/category_model.dart';
import 'package:casher_pos/features/categories/data/repositories/category_repository.dart';
import 'package:casher_pos/shared/dtos/response_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository repository;

  CategoryCubit({required this.repository}) : super(const CategoryState());

  void _safeEmit(CategoryState newState) {
    if (!isClosed) emit(newState);
  }

  Future<void> loadCategories() async {
    _safeEmit(state.copyWith(status: CategoryStatus.loading));

    try {
      final categories = await repository.getAllCategories();
      _safeEmit(
        state.copyWith(status: CategoryStatus.success, categories: categories),
      );
    } catch (e) {
      _safeEmit(
        state.copyWith(status: CategoryStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<ResponseDto<String>> storeCategory(StoreCategoryDto dto) async {
    try {
      final category = CategoryModel(name: dto.name, createdAt: DateTime.now());
      await repository.storeCategory(category);
      await loadCategories();

      return ResponseDto(success: true, response: "Berhasil menyimpan kategori");
    } catch (e) {
      return ResponseDto(success: false, response: e.toString());
    }
  }

  Future<ResponseDto<String>> deleteCategory(int id) async {
    try {
      await repository.deleteCategory(id);
      await loadCategories();

      return ResponseDto(success: true, response: "Berhasil menghapus kategori");
    } catch (e) {
      return ResponseDto(success: false, response: e.toString());
    }
  }
}
