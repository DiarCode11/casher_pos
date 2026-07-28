import 'package:casher_pos/shared/widgets/sidebar_menu.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget content;
  final String currentPath;
  const AppScaffold({required this.content, required this.currentPath, super.key});

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