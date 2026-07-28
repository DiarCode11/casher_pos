import 'package:casher_pos/features/products/cubit/product_cubit.dart';
import 'package:casher_pos/features/products/cubit/product_state.dart';
import 'package:casher_pos/features/products/data/repositories/product_repository.dart';
import 'package:casher_pos/features/products/presentation/widgets/product_card.dart';
import 'package:casher_pos/features/sales/presentation/widget/sales_top_bar_widget.dart';
import 'package:casher_pos/shared/widgets/custom_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:casher_pos/core/di/injection.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  Widget _buildContent(ProductState state) {
    return switch (state.status) {
      ProductStatus.loading => const Center(child: CircularProgressIndicator()),
      ProductStatus.failure => Center(child: Text(state.errorMessage ?? 'Error')),
      ProductStatus.success when state.products.isEmpty => const Center(child: Text('Belum ada produk')),
      ProductStatus.success => CustomTable(
        columns: const [
          DriveTableColumn(label: 'Nama Produk', flex: 3),
          DriveTableColumn(label: 'Harga', flex: 1),
          DriveTableColumn(label: 'Stok', flex: 1),
        ], 
        rows: state.products.map((p) {
          return DriveTableRow(
            icon: Icons.inventory_2_outlined,
            iconColor: p.stock == 0 ? Colors.red : Colors.blue,
            cells: [p.name, 'Rp${p.price}', p.stock.toString()],
            onTap: () {
              // buka detail produk
            },
            trailingActions: [
              IconButton(icon: const Icon(Icons.more_vert, size: 18), onPressed: () {}),
            ],
          );
        }).toList()),
    _ => const SizedBox(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BlocProvider(
            create: (_) => ProductCubit(repository: getIt<ProductRepository>())..loadProducts(),
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SalesTopBarWidget(),
                    const SizedBox(height: 16),

                    Expanded(
                      child: _buildContent(state),
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