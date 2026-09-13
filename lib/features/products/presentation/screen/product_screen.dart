import 'package:casher_pos/core/extensions/currency_ext.dart';
import 'package:casher_pos/features/products/cubit/product_cubit.dart';
import 'package:casher_pos/features/products/cubit/product_state.dart';
import 'package:casher_pos/features/products/data/models/product_model.dart';
import 'package:casher_pos/features/products/presentation/widgets/update_modal.dart';
import 'package:casher_pos/features/sales/cubit/sales_cubit.dart';
import 'package:casher_pos/features/sales/cubit/sales_state.dart';
import 'package:casher_pos/features/sales/data/models/sales_product_model.dart';
import 'package:casher_pos/features/products/presentation/widgets/product_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:casher_pos/features/products/presentation/widgets/add_modal.dart';

DataRow _productRow(ProductModel product, int index, {
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
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
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: PopupMenuButton<String>(
            color: Colors.white,
            icon: Icon(LucideIcons.ellipsisVertical, color: Colors.grey.shade700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => {},
                value: 'edit',
                child: Row(
                  children: [
                    Icon(LucideIcons.pencil, size: 18, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2, size: 18, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Hapus', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    ],
  );
}

Future<void> _handleDeleteProduct(
  BuildContext context,
  BuildContext dialogContext,
  int productId,
) async {
  final productCubit = context.read<ProductCubit>();
  final res = await productCubit.deleteProduct(productId);
  if (!context.mounted) return;
  if (!res.success) {
    Navigator.pop(dialogContext);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res.response),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red.shade400,
      ),
    );
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Produk berhasil dihapus'),
      duration: Duration(seconds: 2),
    ),
  );
  productCubit.loadProducts();
  Navigator.pop(dialogContext);
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  void _openAddProductDialog(BuildContext context) {
    final productCubit = context.read<ProductCubit>();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: productCubit,
          child: const AddModal(),
        );
      },
    );
  }

  void _openUpdateProductDialog(BuildContext context, ProductModel model) {
    final productCubit = context.read<ProductCubit>();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: productCubit,
          child: UpdateModal(model: model),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductTopBar(),
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
                            _openAddProductDialog(context);
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
                    child: BlocBuilder<ProductCubit, ProductState>(
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
                                          DataColumn(label: Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold)),),
                                          )),
                                        ],
                                        rows: [
                                          for (var index = 0; index < state.products.length; index++)
                                            _productRow(
                                              state.products[index],
                                              index,
                                              onEdit: () {
                                                final product = state.products[index];
                                                _openUpdateProductDialog(context, state.products[index]);
                                              },
                                              onDelete: () {
                                                final product = state.products[index];
                                                final productCubit = context.read<ProductCubit>();
                                                
                                                showDialog(
                                                  context: context,
                                                  builder: (dialogContext) {
                                                    return Dialog(
                                                      backgroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: ConstrainedBox(
                                                        constraints: const BoxConstraints(maxWidth: 380),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(24),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Container(
                                                                width: 56,
                                                                height: 56,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.red.shade50,
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: Icon(
                                                                  Icons.delete_outline,
                                                                  color: Colors.red.shade600,
                                                                  size: 28,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 16),
                                                              const Text(
                                                                'Hapus Produk?',
                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                              ),
                                                              const SizedBox(height: 8),
                                                              Text(
                                                                'Apakah kamu yakin ingin menghapus "${product.name}"? Tindakan ini tidak bisa dibatalkan.',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                                              ),
                                                              const SizedBox(height: 24),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: OutlinedButton(
                                                                      onPressed: () => Navigator.pop(dialogContext),
                                                                      style: OutlinedButton.styleFrom(
                                                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                                                        side: BorderSide(color: Colors.grey.shade300),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                        ),
                                                                      ),
                                                                      child: const Text('Batal', style: TextStyle(color: Colors.black87)),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 12),
                                                                  Expanded(
                                                                    child: ElevatedButton(
                                                                      onPressed: () => _handleDeleteProduct(context, dialogContext, product.id!),
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor: Colors.red.shade600,
                                                                        foregroundColor: Colors.white,
                                                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                        ),
                                                                        elevation: 0,
                                                                      ),
                                                                      child: const Text('Hapus'),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
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