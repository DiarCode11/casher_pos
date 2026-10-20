import 'package:casher_pos/features/purchase/presentation/widgets/purchase_top_bar.dart';
import 'package:flutter/material.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PurchaseTopBar()
      ],
    );
  }
}