import 'package:casher_pos/features/products/cubit/product_state.dart';
import 'package:casher_pos/features/products/data/models/product_model.dart';
import 'package:casher_pos/features/sales/cubit/sales_state.dart';
import 'package:casher_pos/features/sales/data/repositories/sales_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesCubit extends Cubit<SalesState> {
  final SalesRepository repository;
  SalesCubit({required this.repository}) : super(const SalesState());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: SalesStatus.loading));
    if (isClosed) return; 

    final products = await repository.getProducts();
    if (isClosed) return; 

    emit(state.copyWith(status: SalesStatus.success, products: products));
  }

  int getStock(int id) => state.products.where((item) => item.id == id).first.stock;
}