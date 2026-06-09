import 'package:flutter/material.dart';
import 'package:flutter_getx_app/features/business/domain/models/business.dart';
import 'package:flutter_getx_app/features/business/domain/repositories/business_repository.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final BusinessRepository _businessRepository;

  SettingsController(this._businessRepository);

  final RxBool isDarkMode = false.obs;
  final RxList<Business> businesses = <Business>[].obs;

  @override
  onReady() async {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode.value = brightness == Brightness.dark;

    // Now take control away from system and use our own value
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    businesses.value = await _businessRepository.getAll();
    super.onReady();
  }

  void onEditBusiness() {
    Get.toNamed('/business-setup', arguments: businesses.first)
        ?.then((value) async {
      if (value == true) {
        // Refresh the business list after returning from the edit screen
        businesses.value = await _businessRepository.getAll();
      }
    });
  }

  void onChangeLogo() {}

  void onInvoicePrefix() {}

  void onTaxSettings() {}

  void onCurrency() {}

  void onBluetoothPrinter() {}

  void onBackupRestore() => Get.toNamed('/backup-restore');

  void toggleTheme() {
    isDarkMode.toggle();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
