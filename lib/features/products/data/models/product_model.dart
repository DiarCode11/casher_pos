import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String name;
  final int price;
  final int stock;
  final DateTime createdAt;
  final String imagePath;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.imagePath
  });

  @override
  List<Object> get props => [id, name, price, stock, createdAt, imagePath];

  factory ProductModel.fromMap(Map<String, dynamic> raw) {
    return ProductModel(
      id: raw['id'] as int,
      name: raw['name'] as String,
      price: raw['price'] as int,
      stock: raw['stock'] as int,
      createdAt: DateTime.parse(raw['created_at'] as String),
      imagePath: raw['image_path']
    );
  }
}