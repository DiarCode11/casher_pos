import 'package:equatable/equatable.dart';

class SalesProductModel extends Equatable {
  final int id;
  final String name;
  final int price;
  final int stock;
  final String? imagePath;

  SalesProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.imagePath
  });

  @override
  List<Object> get props => [id, name, price, stock];

  factory SalesProductModel.fromMap(Map<String, dynamic> raw) {
    return SalesProductModel(
      id: raw['id'] as int,
      name: raw['name'] as String,
      price: raw['price'] as int,
      stock: raw['stock'] as int,
      imagePath: raw['image_path'] as String?
    );
  }
}