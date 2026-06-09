import 'package:flutter/material.dart';
import 'package:flutter_getx_app/core/services/local_storage_service.dart';
import 'package:get/get.dart';
import 'core/configs/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

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
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      builder: (_, child) {
        return SafeArea(top: false, child: child!);
      },
    );
  }
}
