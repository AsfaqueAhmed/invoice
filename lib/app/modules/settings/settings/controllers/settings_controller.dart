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
    businesses.value = await BusinessLocalDatasource().getAll();
    super.onReady();
  }

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
