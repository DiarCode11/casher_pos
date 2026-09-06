import 'package:casher_pos/features/products/presentation/screen/product_screen.dart';
import 'package:casher_pos/features/sales/presentation/screens/sales_screen.dart';
import 'package:casher_pos/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/sales', 
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Oper navigationShell ke AppScaffold
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Index 0: Penjualan
        StatefulShellBranch(routes: [GoRoute(path: '/sales', builder: (context, state) => const SalesScreen())]),
        // Index 1: Pembelian
        StatefulShellBranch(routes: [GoRoute(path: '/purchases', builder: (context, state) => const ProductScreen())]),
        // Index 2: Transaksi
        StatefulShellBranch(routes: [GoRoute(path: '/transaction', builder: (context, state) => const ProductScreen())]),
        // Index 3: Produk
        StatefulShellBranch(routes: [GoRoute(path: '/product', builder: (context, state) => const ProductScreen())]),
        // Index 4: Stok (Ganti layarnya sesuai milik Anda)
        StatefulShellBranch(routes: [GoRoute(path: '/stock', builder: (context, state) => const Scaffold(body: Center(child: Text('Stok'))))]),
        // Index 5: Laporan
        StatefulShellBranch(routes: [GoRoute(path: '/report', builder: (context, state) => const Scaffold(body: Center(child: Text('Laporan'))))]),
        // Index 6: User & Kasir
        StatefulShellBranch(routes: [GoRoute(path: '/user', builder: (context, state) => const Scaffold(body: Center(child: Text('User'))))]),
        // Index 7: Pengaturan
        StatefulShellBranch(routes: [GoRoute(path: '/settings', builder: (context, state) => const Scaffold(body: Center(child: Text('Pengaturan'))))]),
      ],
    ),

    // Route Login/Logout di luar karena tidak pakai Sidebar
    GoRoute(
      path: '/login',
      builder: (context, state) => const Scaffold(body: Center(child: Text('Halaman Login'))),
    ),
  ]
);