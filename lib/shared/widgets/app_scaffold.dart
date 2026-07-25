import 'package:casher_pos/features/sales/presentation/widget/sales_top_bar_widget.dart';
import 'package:casher_pos/shared/widgets/sidebar_menu.dart';
import 'package:casher_pos/shared/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget content;
  final String currentPath;
  const AppScaffold({required this.content, required this.currentPath, super.key});

  Widget _buildTopbarByPath(String path) {
    switch (path) {
      case '/sales':
        return SalesTopBarWidget();
      default:
        return const Text(
        'Halaman',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ); // Return widget kosong
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SidebarMenu(),
          Expanded(
            child: Container(
              color: const Color(0xFFF5F6FA),
              child: Row(
                children: [
                  Expanded(child: content)
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}