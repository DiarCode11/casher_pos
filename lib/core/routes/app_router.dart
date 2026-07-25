import 'package:casher_pos/features/products/presentation/screen/product_list_screen.dart';
import 'package:casher_pos/features/sales/presentation/screens/sales_screen.dart';
import 'package:casher_pos/shared/widgets/app_scaffold.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/sales', 
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppScaffold(content: child, currentPath: state.uri.path),
      routes: [
        GoRoute(
          path: '/sales',
          builder: (context, state) => const SalesScreen(),
        ),
        GoRoute(
          path: '/purchases',
          builder: (context, state) => const ProductListScreen(),
        ),
        GoRoute(
          path: '/product',
          builder: (context, state) => const ProductListScreen(),
        ),
        GoRoute(
          path: '/transaction',
          builder: (context, state) => const ProductListScreen(),
        ),
      ]
    )
  ]
);