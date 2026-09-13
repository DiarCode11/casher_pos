import 'dart:io';

import 'package:casher_pos/features/sales/cubit/cart_state.dart';
import 'package:casher_pos/features/sales/cubit/sales_cubit.dart';
import 'package:casher_pos/features/sales/cubit/sales_state.dart';
import 'package:casher_pos/features/sales/cubit/cart_cubit.dart';
import 'package:casher_pos/features/sales/data/models/cart_item_model.dart';
import 'package:casher_pos/features/sales/presentation/widget/cart_widget.dart';
import 'package:casher_pos/features/sales/presentation/widget/sales_top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SalesCubit>().loadProducts();
  }

  void _openCartModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // penting biar bisa custom height & gak kepotong keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85, // atur tinggi modal, misal 85% layar
          child: const CartWidget(), // widget cart kamu yang sudah ada
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              SalesTopBarWidget(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Expanded(
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
                              // Kolom Pencarian
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                              ),
                            ),
                            SizedBox(height: 12),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
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
                                    if (state.status == SalesStatus.loading) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    // 3. Tampilkan pesan kosong jika tidak ada produk
                                    if (state.products.isEmpty) {
                                      return const Center(child: Text('Tidak ada produk tersedia.'));
                                    }

                                    return GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 0.8, // lebar : tinggi. Makin kecil, makin tinggi item-nya
                                      ),
                                      padding: EdgeInsets.all(12),
                                      itemCount: state.products.length,
                                      itemBuilder: (context, index) {
                                        final product = state.products[index];

                                        return BlocBuilder<CartCubit, CartState>(
                                          builder: (context, state) {
                                            final isInCart = context.read<CartCubit>().isProductInCart(product.id);
                                            final isLimitReached = context.read<CartCubit>().isStockLimitReached(product.id);

                                            return Stack(
                                              children: [
                                                Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(color: isInCart ? Colors.green.shade500 : Colors.grey.shade200, width: isInCart ? 2 : 1),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min, // penting: Column jangan minta lebih dari yg dibutuhkan
                                                    children: [
                                                      // Gambar - pakai Expanded, bukan AspectRatio
                                                      Expanded(
                                                        child: product.imagePath != null && File(product.imagePath!).existsSync()
                                                          ? Image.file(
                                                              File(product.imagePath!),
                                                              fit: BoxFit.cover,
                                                              width: double.infinity,
                                                              height: 20,
                                                              errorBuilder: (context, error, stackTrace) {
                                                                return Container(
                                                                  color: Colors.grey[300],
                                                                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                                                                );
                                                              },
                                                            )
                                                          : Container(
                                                              color: Colors.grey[300],
                                                              width: double.infinity,
                                                              child: Icon(Icons.image_not_supported, color: Colors.grey),
                                                            ),
                                                      ),
                                                
                                                      // Nama dan harga
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              product.name,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                            ),
                                                            SizedBox(height: 2),
                                                            Text(
                                                              'Stok: ${product.stock}',
                                                              style: TextStyle(
                                                                color: Colors.grey.shade600,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Rp ${product.price}',
                                                              style: TextStyle(
                                                                color: isInCart ? Colors.green[700] : Colors.grey[700],
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            SizedBox(height: 10),
                                                            SizedBox(
                                                              width: double.infinity,
                                                              child: isLimitReached 
                                                                ? Container(
                                                                  height: 30,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.grey.shade300,
                                                                    // Atur kelengkungan sudut di sini:
                                                                    borderRadius: BorderRadius.circular(8), 
                                                                  ),
                                                                  child: Center(
                                                                    child: Text("Stok Habis"),
                                                                  )
                                                                )
                                                                : TextButton(
                                                                onPressed: () {
                                                                  context.read<CartCubit>().addItem(
                                                                        CartItemModel(
                                                                          productId: product.id,
                                                                          name: product.name,
                                                                          price: product.price,
                                                                        ),
                                                                      );
                                                                },
                                                                style: TextButton.styleFrom(
                                                                  backgroundColor: isInCart ? Colors.green.shade100 : Colors.green.shade500,
                                                                  foregroundColor: isInCart ? Colors.green.shade700 : Colors.white,
                                                                  padding: EdgeInsets.symmetric(vertical: 12),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                    isInCart ? "Ditambahkan" : "Tambahkan", 
                                                                  style: TextStyle(fontWeight: FontWeight(600)),),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (isInCart) 
                                                  Positioned(
                                                    top: 8,
                                                    right: 8,
                                                    child: Container(
                                                      padding: const EdgeInsets.all(4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green.shade600,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          }
                                        );
                                      },
                                    );
                                  })
                              ),        
                            )
                          ],
                        )
                      ),
                      SizedBox(width: 12),
                      SizedBox(
                        width: 350,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CartWidget(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}