import 'package:casher_pos/core/database/database_helper.dart';
import 'package:casher_pos/core/di/injection.dart';
import 'package:casher_pos/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // wajib, karena ada kode async sebelum runApp
  await setupLocator();
  await getIt<DatabaseHelper>().database;   // <-- di sini database dibuat/dibuka
  runApp(const MyApp());
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
    return MaterialApp.router(
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
    );
  }
}

