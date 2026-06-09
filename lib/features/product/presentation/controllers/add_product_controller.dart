import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_getx_app/core/utils/image_utils.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_list_controller.dart';

class AddProductController extends GetxController {
  final ProductRepository _repository;

  AddProductController(this._repository);

  final formKey = GlobalKey<FormState>();
  final RxBool isSaving = false.obs;
  final RxBool isActive = true.obs;
  final RxString selectedCategory = ''.obs;
  final Rx<File?> productImage = Rx<File?>(null);

  late final Product? editingProduct;

  final nameController = TextEditingController();
  final skuController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final descController = TextEditingController();
  final purchasePriceController = TextEditingController();

  static const List<String> categories = [
    'General',
    'Food',
    'Beverages',
    'Electronics',
    'Computer & IT',
    'Mobile & Accessories',
    'Clothing',
    'Footwear',
    'Beauty & Personal Care',
    'Health & Medicine',
    'Home & Kitchen',
    'Furniture',
    'Books & Stationery',
    'Sports & Fitness',
    'Toys & Games',
    'Automotive',
    'Hardware & Tools',
    'Pet Supplies',
    'Services',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    selectedCategory.value = categories.first;
    editingProduct = Get.arguments as Product?;
    if (editingProduct != null) {
      nameController.text = editingProduct!.name;
      skuController.text = editingProduct!.sku;
      priceController.text = editingProduct!.sellingPrice.toString();
      stockController.text = editingProduct!.stock.toString();
      descController.text = editingProduct!.description ?? '';
      purchasePriceController.text = editingProduct!.purchasePrice.toString();
      if (editingProduct!.image?.isNotEmpty ?? false) {
        productImage.value = File(editingProduct!.image!);
      }
      selectedCategory.value = categories.firstWhere(
        (c) => c == editingProduct!.category,
        orElse: () => categories.first,
      );
      isActive.value = editingProduct!.isActive;
    }
  }

  void onCategorySelect(String cat) => selectedCategory(cat);

  String? validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  Future<void> onSave() async {
    if (!formKey.currentState!.validate()) return;
    isSaving(true);
    try {
      final imagePath = await _resolveImagePath();
      final product = Product(
        id: const Uuid().v4(),
        name: nameController.text.trim(),
        sku: _resolveSku(),
        category: selectedCategory.value,
        purchasePrice: double.tryParse(purchasePriceController.text) ?? 0,
        sellingPrice: double.tryParse(priceController.text) ?? 0,
        stock: int.tryParse(stockController.text) ?? 0,
        description: descController.text.trim(),
        image: imagePath ?? '',
        isActive: isActive.value,
      );
      await _repository.create(product);
      Get.back(result: true);
      Get.snackbar('Success', 'Product saved!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    } catch (_) {
      Get.snackbar('Error', 'Could not save product.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving(false);
    }
  }

  Future<void> onUpdate() async {
    if (!formKey.currentState!.validate()) return;
    isSaving(true);
    try {
      final imagePath = await _resolveImagePath();
      final product = Product(
        id: editingProduct!.id,
        name: nameController.text.trim(),
        sku: _resolveSku(),
        category: selectedCategory.value,
        purchasePrice: double.tryParse(purchasePriceController.text) ?? 0,
        sellingPrice: double.tryParse(priceController.text) ?? 0,
        stock: int.tryParse(stockController.text) ?? 0,
        description: descController.text.trim(),
        image: imagePath ?? '',
        isActive: isActive.value,
      );
      await _repository.update(product);
      Get.until((route) => route.settings.name == '/product-list');
      if (Get.isRegistered<ProductListController>()) {
        Get.find<ProductListController>().refresh();
      }
      Get.snackbar('Success', 'Product updated!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    } catch (_) {
      Get.snackbar('Error', 'Could not update product.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving(false);
    }
  }

  Future<void> onPickImage() async {
    final picked = await ImageUtils.pickImageFromGallery();
    if (picked != null) productImage(File(picked.path));
  }

  void toggleActive() => isActive.value = !isActive.value;

  Future<String?> _resolveImagePath() async {
    if (productImage.value != null) {
      return ImageUtils.saveProductImage(productImage.value!);
    }
    return null;
  }

  String _resolveSku() {
    final sku = skuController.text.trim();
    return sku.isEmpty ? 'SKU-${DateTime.now().millisecondsSinceEpoch}' : sku;
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
