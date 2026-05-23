import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/configs/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX App',
      debugShowCheckedModeBanner: false,

      // ─── Theme ──────────────────────────────────────────────
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // ─── Routes ─────────────────────────────────────────────
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      // ─── Locale (optional) ──────────────────────────────────
      // locale: const Locale('en', 'US'),
      // fallbackLocale: const Locale('en', 'US'),
    );
  }
}
