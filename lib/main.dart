import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/core/di/injection.dart';
import 'package:casher_pos/core/routes/app_router.dart';
import 'package:casher_pos/features/categories/cubit/category_cubit.dart';
import 'package:casher_pos/features/products/cubit/product_cubit.dart';
import 'package:casher_pos/features/sales/cubit/cart_cubit.dart';
import 'package:casher_pos/features/sales/cubit/sales_cubit.dart';
import 'package:casher_pos/features/sales/data/repositories/sales_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // wajib, karena ada kode async sebelum runApp
  await setupLocator();
  await getIt<DatabaseHelper>().database;   // <-- di sini database dibuat/dibuka
  runApp(
    const MyApp());
}

class NoTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SalesCubit(repository: getIt<SalesRepository>())..loadProducts()),
        BlocProvider(create: (context) {
          return CartCubit(salesCubit: context.read<SalesCubit>());
        }),
         BlocProvider(create: (context) => getIt<ProductCubit>()..loadProducts()),
         BlocProvider(create: (context) => getIt<CategoryCubit>()..loadCategories()),
      ], 
      child: MaterialApp.router(
        title: 'Casher POS',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android:NoTransitionsBuilder(),
              TargetPlatform.iOS: NoTransitionsBuilder(),
              TargetPlatform.windows: NoTransitionsBuilder(),
            },
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white, // ganti sesuai warna tema kasirmu
          ),
          scaffoldBackgroundColor: Colors.transparent,
        ),
        routerConfig: appRouter,
      )
    );
  }
}

