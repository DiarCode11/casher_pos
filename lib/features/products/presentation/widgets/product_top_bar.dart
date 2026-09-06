import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProductTopBar extends StatelessWidget {
  const ProductTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 2
          ))
        ),
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Produk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Kelola data produk dengan mudah", style: TextStyle(fontSize: 14, color: Colors.grey.shade600))
                ],
              ),
            ],
          ),
        )
    );
  }
}