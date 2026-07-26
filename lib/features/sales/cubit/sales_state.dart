import 'package:casher_pos/features/products/data/models/product_model.dart';
import 'package:casher_pos/features/sales/data/models/sales_product_model.dart';
import 'package:equatable/equatable.dart';

enum SalesStatus { initial, loading, success, failure }
class SalesState extends Equatable {
  final SalesStatus status;
  final List<SalesProductModel> products;
  final String? errorMessage;

  const SalesState({
    this.status = SalesStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  SalesState copyWith({
    SalesStatus? status,
    List<SalesProductModel>? products,
    String? errorMessage,
  }) {
    return SalesState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}