import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int? id;
  final String name;
  final int price;
  final int stock;
  final DateTime createdAt;
  final String? imagePath;
  final DateTime? deletedAt;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.imagePath,
    this.deletedAt
  });

  @override
  List<Object> get props => [name, price, stock, createdAt];

  factory ProductModel.fromMap(Map<String, dynamic> raw) {
    return ProductModel(
      id: raw['id'] as int,
      name: raw['name'] as String,
      price: raw['price'] as int,
      stock: raw['stock'] as int,
      createdAt: DateTime.parse(raw['created_at'] as String),
      imagePath: raw['image_path'],
      deletedAt: raw['deleted_at'] != null 
        ? DateTime.parse(raw['deleted_at'] as String)
        : null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "stock": stock,
      "created_at": createdAt.toString(),
      "image_path": imagePath,
      "deleted_at": deletedAt
    };
  }
}