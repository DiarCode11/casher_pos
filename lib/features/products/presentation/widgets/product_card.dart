import 'package:casher_pos/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('Price: ${product.price}'),
        trailing: Text('Stock: ${product.stock}'),  
      ),
    );
  }
}