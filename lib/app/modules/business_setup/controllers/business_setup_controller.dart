import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/services/local_storage_service.dart';
import 'package:flutter_getx_app/app/core/utils/image_utils.dart';
import 'package:flutter_getx_app/app/data/datasources/local/business_local_datasource.dart';
import 'package:flutter_getx_app/app/data/entities/business_entity.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../routes/app_pages.dart';

class BusinessSetupController extends GetxController {
  // ─── Form Key ─────────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();

  // ─── Text Controllers ─────────────────────────────────────────
  final businessNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // ─── State ────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxBool isSuccess = false.obs;
  final Rx<File?> logoFile = Rx<File?>(null);
  final RxString selectedCurrency = 'BDT'.obs;

  // ─── Currency Options ─────────────────────────────────────────
  final List<Map<String, String>> currencies = const [
    {'value': 'USD', 'label': 'USD - US Dollar'},
    {'value': 'EUR', 'label': 'EUR - Euro'},
    {'value': 'GBP', 'label': 'GBP - British Pound'},
    {'value': 'CAD', 'label': 'CAD - Canadian Dollar'},
    {'value': 'AUD', 'label': 'AUD - Australian Dollar'},
    {'value': 'BDT', 'label': 'BDT - Bangladeshi Taka'},
  ];

  final _repository = BusinessLocalDatasource();

  // ─── Actions ──────────────────────────────────────────────────

  void onCurrencyChanged(String? value) {
    if (value != null) selectedCurrency(value);
  }

  Future<void> pickLogo() async {
    final picked = await ImageUtils.pickImageFromGallery();
    if (picked != null) logoFile(File(picked.path));
  }

  Future<void> onSubmit() async {
    if (!formKey.currentState!.validate()) return;

    isLoading(true);

    try {
      String? savedImageDirectory;
      if (logoFile.value != null) {
        savedImageDirectory = await ImageUtils.saveBusinessImage(
          logoFile.value!,
        );
      }

      final data = BusinessEntity(
        id: const Uuid().v4(),
        name: businessNameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        currency: selectedCurrency.value,
        logo: savedImageDirectory ?? '',
      );
      await _repository.create(data);

      await Future.delayed(const Duration(milliseconds: 1500));

      isSuccess(true);

      await Future.delayed(const Duration(milliseconds: 600));

      await LocalStorageService.setOnCreatedFirstBusiness();

      Get.offAllNamed(Routes.dashboard);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save business profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    businessNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
