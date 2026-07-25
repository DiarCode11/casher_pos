import 'package:flutter/material.dart';

class ProductSearchBar extends StatelessWidget {
  const ProductSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Membuat sudutnya melengkung (opsional)
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Efek bayangan halus
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Cari produk...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none, // Menghilangkan garis bawaan
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}