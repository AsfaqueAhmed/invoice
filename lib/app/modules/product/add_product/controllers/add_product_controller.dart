import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  final nameController = TextEditingController();
  final skuController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final descController = TextEditingController();
  final RxString selectedCategory = 'Beverages'.obs;
  final RxBool isSaving = false.obs;
  final formKey = GlobalKey<FormState>();
  final categories = [
    'Beverages',
    'Bakery',
    'Dairy',
    'Merchandise',
    'Hardware',
    'Services'
  ];

  void onCategorySelect(String c) => selectedCategory(c);

  Future<void> onSave() async {
    if (!formKey.currentState!.validate()) return;
    isSaving(true);
    await Future.delayed(const Duration(milliseconds: 1500));
    isSaving(false);
    Get.back();
    Get.snackbar('Success', 'Product saved successfully',
        snackPosition: SnackPosition.BOTTOM);
  }

  String? validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  @override
  void onClose() {
    nameController.dispose();
    skuController.dispose();
    priceController.dispose();
    stockController.dispose();
    descController.dispose();
    super.onClose();
  }
}
