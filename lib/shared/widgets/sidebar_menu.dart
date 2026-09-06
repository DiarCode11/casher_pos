// shared/widgets/sidebar_menu.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SidebarMenu extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const SidebarMenu({required this.navigationShell, super.key});

  // String route dihapus karena kita pakai urutan Index sekarang
  static const List<_MenuData> _menus = [
    _MenuData(LucideIcons.shoppingCart, 'Penjualan'), // Index 0
    _MenuData(LucideIcons.shoppingBag, 'Pembelian'),  // Index 1
    _MenuData(LucideIcons.receipt, 'Transaksi'),      // Index 2
    _MenuData(LucideIcons.package, 'Produk'),         // Index 3
    _MenuData(LucideIcons.warehouse, 'Stok'),         // Index 4
    _MenuData(LucideIcons.barChart2, 'Laporan'),      // Index 5
    _MenuData(LucideIcons.users, 'User & Kasir'),     // Index 6
    _MenuData(LucideIcons.settings, 'Pengaturan'),    // Index 7
  ];

  @override
  Widget build(BuildContext context) {
    // Ambil index tab yang sedang aktif
    final activeIndex = navigationShell.currentIndex;

    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200, width: 2),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.point_of_sale, color: Colors.green.shade700, size: 20),
          ),
          const SizedBox(height: 28),

          // Menu Items
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              // Gunakan asMap untuk mendapatkan Index dan Value (Menu)
              children: _menus.asMap().entries.map((entry) {
                final index = entry.key;
                final menu = entry.value;
                
                return _MenuItem(
                  icon: menu.icon,
                  label: menu.label,
                  isActive: activeIndex == index,
                  onTap: () {
                    // Pindah tab menggunakan index branch
                    navigationShell.goBranch(
                      index,
                      // Jika tab yang sama di-klik, reset ke halaman awalnya
                      initialLocation: index == navigationShell.currentIndex,
                    );
                  },
                );
              }).toList(),
            ),
          ),

          // Logout tetap pakai context.go karena dia keluar dari sistem tab
          _MenuItem(
            icon: Icons.logout,
            label: 'Logout',
            isActive: false,
            onTap: () => context.go('/login'), 
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _MenuData {
  final IconData icon;
  final String label;
  const _MenuData(this.icon, this.label);
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap; // Ganti dari route String jadi fungsi callback

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  static const Color primaryColor = Color.fromARGB(255, 8, 145, 15);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      preferBelow: false,
      verticalOffset: 8,
      waitDuration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap, // <-- Panggil fungsi yang dikirim dari atas
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              primaryColor.withOpacity(0.15),
                              primaryColor.withOpacity(0.0),
                            ],
                          )
                        : null,
                  ),
                  child: Icon(
                    icon,
                    color: isActive ? primaryColor : Colors.grey.shade500,
                    size: 22,
                  ),
                ),
                if (isActive)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}