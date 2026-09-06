import 'package:casher_pos/shared/widgets/sidebar_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Lempar navigationShell ke SidebarMenu
          SidebarMenu(navigationShell: navigationShell),
          Expanded(
            child: Container(
              color: const Color(0xFFF5F6FA),
              child: Row(
                children: [
                  // Konten utama dirender di sini
                  Expanded(child: navigationShell)
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}