import 'package:casher_pos/core/extensions/currency_ext.dart';
import 'package:casher_pos/features/sales/cubit/sales_cubit.dart';
import 'package:casher_pos/features/sales/cubit/sales_state.dart';
import 'package:casher_pos/features/sales/data/models/sales_product_model.dart';
import 'package:casher_pos/features/sales/presentation/widget/sales_top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

DataRow _productRow(SalesProductModel product, int index) {
  final isAvailable = product.stock > 0;

  return DataRow(
    cells: [
      DataCell(Text('${index + 1}')),
      DataCell(
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 220),
          child: Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      DataCell(Text(product.price.toRupiah())),
      DataCell(Text('${product.stock}')),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isAvailable ? Colors.green.shade50 : Colors.red.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isAvailable ? 'Tersedia' : 'Stok habis',
            style: TextStyle(
              color: isAvailable ? Colors.green.shade700 : Colors.red.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    ],
  );
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SalesTopBarWidget(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari produk...',
                              prefixIcon: Icon(LucideIcons.search, color: Colors.grey.shade600),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          
                          },
                          
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Tambah Produk", 
                            style: TextStyle(fontWeight: FontWeight(600)),),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: BlocBuilder<SalesCubit, SalesState>(
                      builder: (context, state) {
                        if (state.status == SalesStatus.loading ||
                            state.status == SalesStatus.initial) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (state.status == SalesStatus.failure) {
                          return Center(
                            child: Text(state.errorMessage ?? 'Gagal memuat produk'),
                          );
                        }

                        if (state.products.isEmpty) {
                          return const Center(child: Text('Belum ada produk.'));
                        }

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: DataTable(
                                        headingRowColor: WidgetStatePropertyAll(
                                          Colors.white,
                                        ),
                                        dataRowMinHeight: 40,
                                        dataRowMaxHeight: 50,
                                        columnSpacing: 28,
                                        columns: const [
                                          DataColumn(label: Text('No.', style: TextStyle(fontWeight: FontWeight.bold),)),
                                          DataColumn(label: Text('Produk', style: TextStyle(fontWeight: FontWeight.bold))),
                                          DataColumn(label: Text('Harga', style: TextStyle(fontWeight: FontWeight.bold))),
                                          DataColumn(label: Text('Stok', style: TextStyle(fontWeight: FontWeight.bold))),
                                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                                        ],
                                        rows: [
                                          for (var index = 0;
                                              index < state.products.length;
                                              index++)
                                            _productRow(state.products[index], index),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          )
        )
      ]
    );
  }
}