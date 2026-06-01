import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/services/local_storage_service.dart';
import 'package:get/get.dart';
import 'app/core/configs/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'InvoiceFlow',
      debugShowCheckedModeBanner: false,

      // ── Theme ─────────────────────────────────────────────
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // ── Routes ────────────────────────────────────────────
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
