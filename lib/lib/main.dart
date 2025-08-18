// lib/main.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:minimal/components/route_generator.dart';
import 'package:minimal/utils/no_animation_page_transitions_builder.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // обертка ResponsiveBreakpoints
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
        child: child!,
      ),

      // Настройки темы
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.fuchsia: NoAnimationPageTransitionsBuilder(),
            TargetPlatform.linux: NoAnimationPageTransitionsBuilder(),
            TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
            TargetPlatform.windows: NoAnimationPageTransitionsBuilder(),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,

      // --- ЛОГИКА МАРШРУТИЗАЦИИ ---
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      // onUnknownRoute можно не указывать, так как onGenerateRoute
      // уже обрабатывает все случаи через default в switch.
    );
  }
}
