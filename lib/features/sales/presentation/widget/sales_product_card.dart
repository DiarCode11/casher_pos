import 'package:casher_pos/core/extensions/currency_ext.dart';
import 'package:casher_pos/features/products/data/models/product_model.dart';
import 'package:casher_pos/features/sales/cubit/cart_cubit.dart';
import 'package:casher_pos/features/sales/data/models/cart_item_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:casher_pos/features/sales/data/models/sales_product_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SalesProductCard extends StatelessWidget {
  final SalesProductModel product;
  const SalesProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ 1. Mengecek apakah produk ini ada di dalam keranjang
    // Menggunakan select agar Card hanya rebuild jika status isInCart-nya berubah
    final isInCart = context.select<CartCubit, bool>(
      (cubit) => cubit.state.items.any((item) => item.productId == product.id),
    );

    final isStockLimitReached = context.select<CartCubit, bool>(
      (cubit) => cubit.isStockLimitReached(product.id)
    );

    return RepaintBoundary( 
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        // ✅ 2. Menambahkan border hijau jika isInCart = true
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isInCart ? Colors.green : Colors.transparent, // Warna dinamis
            width: 3, // Ketebalan border
          ),
        ),
        // Menghilangkan bayangan default jika sedang di-select agar lebih rapi (opsional)
        elevation: isInCart ? 0 : 2, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'https://picsum.photos/200/200?random=${product.id}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        fadeInDuration: Duration.zero,
                        memCacheWidth: 200, 
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade200,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.white,
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Stock: ${product.stock}',
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                    // ✅ 3. (Opsional) Tambahkan badge "Di Keranjang" di atas gambar
                    if (isInCart)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 14),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(product.price.toRupiah()),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: isStockLimitReached  
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.grey, // Tetap berwarna cerah
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: const Text(
                                'Stok habis',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        )
                        : TextButton.icon(
                          onPressed: () {
                            context.read<CartCubit>().addItem(
                              CartItemModel(
                                productId: product.id,
                                name: product.name,
                                price: product.price,
                                quantity: 1,
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // ✅ 4. (Opsional) Ubah warna tombol jika sudah di keranjang
                            backgroundColor: isInCart ? Colors.green[100] : Colors.green[500],
                            foregroundColor: isInCart ? Colors.green[800] : Colors.white,
                            elevation: 0,
                          ),
                          label: Text(isInCart ? '+ Tambah Lagi' : 'Tambahkan'),
                          icon: const Icon(LucideIcons.shoppingCart400),
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}