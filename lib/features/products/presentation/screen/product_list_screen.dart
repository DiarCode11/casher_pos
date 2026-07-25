import 'package:casher_pos/features/products/cubit/product_cubit.dart';
import 'package:casher_pos/features/products/cubit/product_state.dart';
import 'package:casher_pos/features/products/presentation/widgets/product_card.dart';
import 'package:casher_pos/features/products/presentation/widgets/product_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BlocProvider(
            create: (_) => ProductCubit()..loadProducts(),
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state.status == ProductStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == ProductStatus.failure) {
                  return Center(child: Text(state.errorMessage ?? 'Error'));
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ProductSearchBar(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.products.length,
                        itemBuilder: (context, index) => 
                            ProductCard(product: state.products[index]),
                      ),
                    ),
                  ],
                );
              }
            ),
          )
        )
      ],
    );
  }
}