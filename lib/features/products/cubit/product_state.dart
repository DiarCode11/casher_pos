import 'package:casher_pos/features/products/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

enum ProductStatus { initial, loading, success, failure }
class ProductState extends Equatable {
  final ProductStatus status;
  final List<ProductModel> products;
  final String? errorMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}