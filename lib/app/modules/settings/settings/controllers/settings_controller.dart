import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/data/datasources/local/business_local_datasource.dart';
import 'package:flutter_getx_app/app/data/entities/business_entity.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final RxBool isDarkMode = false.obs;
  final RxList<BusinessEntity> businesses = <BusinessEntity>[].obs;

  @override
  onReady() async {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode.value = brightness == Brightness.dark;

    // Now take control away from system and use our own value
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    super.onReady();
  }

  void onEditBusiness() {
    Get.toNamed(Routes.businessSetup, arguments: businesses.first)
        ?.then((value) async {
      if (value == true) {
        // Refresh the business list after returning from the edit screen
        businesses.value = await BusinessLocalDatasource().getAll();
      }
    });
  }

  void onChangeLogo() {}

  void onInvoicePrefix() {

  }

  void onTaxSettings() {}

  void onCurrency() {}

  void onBluetoothPrinter() {}

  void onBackupRestore() => Get.toNamed(Routes.BACKUP_RESTORE);

  void toggleTheme() {
    isDarkMode.toggle();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
