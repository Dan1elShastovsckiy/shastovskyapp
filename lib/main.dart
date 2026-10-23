// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' show FlutterQuillLocalizations;
import 'package:minimal/firebase_options.dart';
import 'package:minimal/services/auth_service.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:minimal/components/route_generator.dart';
import 'package:minimal/components/theme.dart';
import 'package:minimal/components/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:intl/date_symbol_data_local.dart';
// <<< УБИРАЕМ ИМПОРТЫ, КОТОРЫЕ БОЛЬШЕ НЕ НУЖНЫ НАПРЯМУЮ >>>
// import 'package:google_sign_in/google_sign_in.dart';
// import 'dart:js_interop';
// import 'package:web/web.dart' as web;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('ru_RU', null);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  usePathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // <<< КЛЮЧЕВОЕ ИЗМЕНЕНИЕ: Создаем AuthService, но не инициализируем его сразу >>>
        // Мы передаем его через ChangeNotifierProxyProvider, чтобы отложить "тяжелую" работу.
        ChangeNotifierProxyProvider0<AuthService>(
          create: (_) => AuthService(),
          // update будет вызван после того, как все провайдеры будут готовы
          update: (_, authService) {
            // Запускаем асинхронную инициализацию здесь, когда приложение уже стабильно
            authService?.initialize();
            return authService!;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Логика для пререндера была специфичной для предыдущего подхода.
    // Пока что мы ее убираем, чтобы найти источник ошибки.
    // Если понадобится, вернем в более безопасном виде.
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'SHASTOVSKY',
          locale: const Locale('ru'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru', ''),
            Locale('en', ''),
          ],
          builder: (context, child) => ResponsiveBreakpoints.builder(
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
            child: child!,
          ),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
