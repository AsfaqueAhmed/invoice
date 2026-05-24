import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final RxBool isDarkMode = false.obs;

  void onEditBusiness() {}

  void onChangeLogo() {}

  void onInvoicePrefix() {}

  void onTaxSettings() {}

  void onCurrency() {}

  void onBluetoothPrinter() {}

  void onBackupRestore() => Get.toNamed(Routes.BACKUP_RESTORE);

  void toggleTheme() {
    isDarkMode.toggle();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
