// shared/widgets/sidebar_menu.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  static const List<_MenuData> _menus = [
    _MenuData(Icons.shopping_cart_checkout_sharp, 'Penjualan', '/sales'),
    _MenuData(Icons.shopping_bag, 'Pembelian', '/purchases'),
    _MenuData(Icons.receipt_long, 'Transaksi', '/transaction'),
    _MenuData(Icons.inventory_2, 'Produk', '/product'),
    _MenuData(Icons.warehouse, 'Stok', '/stock'),
    _MenuData(Icons.bar_chart, 'Laporan Penjualan', '/report'),
    _MenuData(Icons.people_outline, 'User & Kasir', '/user'),
    _MenuData(Icons.settings_outlined, 'Pengaturan', '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();

    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Colors.grey.shade200, // warna garis border
            width: 2, // ketebalan border
          ),
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
              children: _menus
                  .map((menu) => _MenuItem(
                        icon: menu.icon,
                        label: menu.label,
                        route: menu.route,
                        isActive: currentPath == menu.route,
                      ))
                  .toList(),
            ),
          ),

          // Logout di bawah
          _MenuItem(
            icon: Icons.logout,
            label: 'Logout',
            route: '/login',
            isActive: false,
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
  final String route;
  const _MenuData(this.icon, this.label, this.route);
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isActive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isActive,
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
          hoverColor: Colors.transparent, // <-- hilangkan warna hover
          splashColor: Colors.transparent, // hilangkan efek splash saat diklik
          highlightColor: Colors.transparent,
          onTap: () => context.go(route),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Stack(
              children: [
                // Background gradasi (kalau aktif)
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

                // Border kiri rounded (kalau aktif)
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