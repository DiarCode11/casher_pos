import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PurchaseTopBar extends StatelessWidget {
  const PurchaseTopBar({super.key});

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
                  Text("Pembelian", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Kelola data pembelian", style: TextStyle(fontSize: 14, color: Colors.grey.shade600))
                ],
              ),
            ],
          ),
        )
    );
  }
}