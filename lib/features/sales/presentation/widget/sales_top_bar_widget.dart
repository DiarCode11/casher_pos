import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SalesTopBarWidget extends StatelessWidget {
  const SalesTopBarWidget({super.key});

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
        child: Row(
          children: [
            SizedBox(width: 20,),
            SizedBox(
              width: 250, // atur sesuai kebutuhan
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari...',
                  prefixIcon: const Icon(LucideIcons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }
}