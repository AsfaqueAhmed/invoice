import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final RxString selectedCurrency = 'USD'.obs;

  // ─── Currency Options ─────────────────────────────────────────
  final List<Map<String, String>> currencies = const [
    {'value': 'USD', 'label': 'USD - US Dollar'},
    {'value': 'EUR', 'label': 'EUR - Euro'},
    {'value': 'GBP', 'label': 'GBP - British Pound'},
    {'value': 'CAD', 'label': 'CAD - Canadian Dollar'},
    {'value': 'AUD', 'label': 'AUD - Australian Dollar'},
    {'value': 'BDT', 'label': 'BDT - Bangladeshi Taka'},
  ];

  // ─── Actions ──────────────────────────────────────────────────

  void onCurrencyChanged(String? value) {
    if (value != null) selectedCurrency(value);
  }

  Future<void> pickLogo() async {
    // TODO: Use image_picker package
    // final picker = ImagePicker();
    // final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    // if (picked != null) logoFile(File(picked.path));
  }

  Future<void> onSubmit() async {
    if (!formKey.currentState!.validate()) return;

    isLoading(true);

    try {
      // TODO: Save business profile to local storage or API
      // final data = BusinessSetupModel(
      //   name: businessNameController.text.trim(),
      //   phone: phoneController.text.trim(),
      //   address: addressController.text.trim(),
      //   currency: selectedCurrency.value,
      //   logoPath: logoFile.value?.path,
      // );
      // await _repository.saveBusinessProfile(data);

      await Future.delayed(const Duration(milliseconds: 1500));

      isSuccess(true);

      await Future.delayed(const Duration(milliseconds: 600));

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

  // ─── Validators ───────────────────────────────────────────────

  String? validateBusinessName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Business name is required';
    }
    if (value.trim().length < 2) {
      return 'Business name must be at least 2 characters';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleaned.length < 7) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    return null;
  }

  @override
  void onClose() {
    businessNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
