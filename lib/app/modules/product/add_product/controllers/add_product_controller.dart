import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_service.dart';
import '../../../../data/datasources/local/product_local_datasource.dart';
import '../../../../data/entities/product_entity.dart';

class AddProductController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final RxBool isSaving = false.obs;
  final RxString selectedCategory = ''.obs;

  final nameController = TextEditingController();
  final skuController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final descController = TextEditingController();
  final purchasePriceController = TextEditingController();

  final categories = ['General', 'Food', 'Electronics', 'Clothing', 'Services'];

  late final ProductLocalDatasource _datasource;

  @override
  void onInit() {
    super.onInit();
    _datasource = ProductLocalDatasource(DatabaseService());
    selectedCategory.value = categories.first;
  }

  void onCategorySelect(String cat) => selectedCategory(cat);

  String? validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  Future<void> onSave() async {
    if (!formKey.currentState!.validate()) return;
    isSaving(true);
    try {
      final entity = ProductEntity(
        id: const Uuid().v4(),
        name: nameController.text.trim(),
        sku: skuController.text.trim().isEmpty
            ? 'SKU-${DateTime.now().millisecondsSinceEpoch}'
            : skuController.text.trim(),
        category: selectedCategory.value,
        purchasePrice: double.tryParse(purchasePriceController.text) ?? 0,
        sellingPrice: double.tryParse(priceController.text) ?? 0,
        stock: int.tryParse(stockController.text) ?? 0,
        description: descController.text.trim().isEmpty
            ? null
            : descController.text.trim(),
      );
      await _datasource.create(entity);
      Get.back(result: true);
      Get.snackbar(
        'Success',
        'Product saved!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not save product.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving(false);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    skuController.dispose();
    priceController.dispose();
    stockController.dispose();
    descController.dispose();
    purchasePriceController.dispose();
    super.onClose();
  }
}
