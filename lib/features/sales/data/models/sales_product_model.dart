import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final int price;
  final int stock;
  final String categoryId;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.categoryId,
  });

  @override
  List<Object> get props => [id, name, price, stock, categoryId];
}