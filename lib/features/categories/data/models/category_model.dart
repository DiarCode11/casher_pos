import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int? id;
  final String name;
  final DateTime createdAt;
  final DateTime? deletedAt;

  const CategoryModel({
    this.id,
    required this.name,
    required this.createdAt,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [id, name, createdAt, deletedAt];

  factory CategoryModel.fromMap(Map<String, dynamic> raw) {
    return CategoryModel(
      id: raw['id'] as int,
      name: raw['name'] as String,
      createdAt: DateTime.parse(raw['created_at'] as String),
      deletedAt: raw['deleted_at'] != null
          ? DateTime.parse(raw['deleted_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "created_at": createdAt.toString(),
      "deleted_at": deletedAt,
    };
  }
}
