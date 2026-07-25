import 'package:casher_pos/features/products/cubit/product_state.dart';
import 'package:casher_pos/features/sales/cubit/sales_cubit.dart';
import 'package:casher_pos/features/sales/presentation/widget/sales_product_card.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCubit, ProductState>(
      builder: (context, state) {
        switch (state.status) {
          case ProductStatus.initial:
            return const SizedBox();

          case ProductStatus.loading:
            return const Center(child: CircularProgressIndicator());

          case ProductStatus.success:
            if (state.products.isEmpty) {
              return const Center(child: Text('Belum ada produk'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return SalesProductCard(product: product);
              },
            );

          case ProductStatus.failure:
            return Center(child: Text('Error: ${state.errorMessage}'));
        }
      }
    );
  }
}