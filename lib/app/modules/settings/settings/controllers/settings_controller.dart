import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/services/local_storage_service.dart';
import 'package:flutter_getx_app/app/data/datasources/local/business_local_datasource.dart';
import 'package:flutter_getx_app/app/data/entities/business_entity.dart';
import 'package:flutter_getx_app/app/modules/settings/settings/views/widgets/invoice_prefix_set_widget.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController invoicePrefixController = TextEditingController();

  final RxList<BusinessEntity> businesses = <BusinessEntity>[].obs;
  final RxBool isDarkMode = false.obs;

  final RxString invoicePrefix = (LocalStorageService.invoicePrefix ?? '').obs;

  double get maxHeight {
    final context = Get.context!;
    return MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;
  }

  @override
  void onInit() {
    super.onInit();

    final savedTheme = LocalStorageService.themeMode;

    if (savedTheme != null) {
      isDarkMode.value = savedTheme == 'dark';
    } else {
      isDarkMode.value =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;
    }
  }

  @override
  void onClose() {
    invoicePrefixController.dispose();
    super.onClose();
  }

  String? validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  void onEditBusiness() {
    Get.toNamed(Routes.businessSetup, arguments: businesses.first)
        ?.then((value) async {
      if (value == true) {
        businesses.value = await BusinessLocalDatasource().getAll();
      }
    });
  }

  void _showBottomSheet(Widget child) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxHeight: maxHeight),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => child,
    );
  }

  void onChangeLogo() {}

  void onInvoicePrefix() {
    _showBottomSheet(InvoicePrefixSetWidget(controller: this));
  }

  void onTaxSettings() {}

  void onCurrency() {}

  void onBluetoothPrinter() {}

  void onBackupRestore() => Get.toNamed(Routes.BACKUP_RESTORE);

  void toggleTheme() async {
    isDarkMode.toggle();
    await LocalStorageService.setThemeMode(
      isDarkMode.value ? 'dark' : 'light',
    );

    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void onSavePrefix() {
    if (formKey.currentState?.validate() == true) {
      // Save the prefix to local storage or database
      LocalStorageService.setInvoicePrefix(invoicePrefixController.text.trim());
      Get.back();
      invoicePrefix.value = LocalStorageService.invoicePrefix ?? '';
      invoicePrefixController.clear();
    }
  }
}
