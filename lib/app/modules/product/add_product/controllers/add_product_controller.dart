import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/utils/image_utils.dart';
import 'package:flutter_getx_app/app/modules/product/product_list/controllers/product_list_controller.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/entities/product_entity.dart';
import '../../../../data/repositories/product_repository.dart';

class AddProductController extends GetxController {
  AddProductController(this._repository);

  final ProductRepository _repository;

  final formKey = GlobalKey<FormState>();
  final RxBool isSaving = false.obs;
  final RxBool isActive = true.obs;
  final RxString selectedCategory = ''.obs;
  late final ProductEntity? product;

  final nameController = TextEditingController();
  final skuController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final descController = TextEditingController();
  final purchasePriceController = TextEditingController();

  final categories = [
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

  final Rx<File?> productImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    selectedCategory.value = categories.first;
    product = Get.arguments as ProductEntity?;
    if (product != null) {
      nameController.text = product!.name;
      skuController.text = product!.sku;
      priceController.text = product!.sellingPrice.toString();
      stockController.text = product!.stock.toString();
      descController.text = product?.description ?? '';
      purchasePriceController.text = product!.purchasePrice.toString();
      productImage.value =
          (product?.image?.isNotEmpty ?? false) ? File(product?.image??'') : null;
      selectedCategory.value = categories.firstWhere(
        (cat) => cat == product!.category,
      );
      isActive.value = product?.isProductActive ?? false;
    }
  }

  void onCategorySelect(String cat) => selectedCategory(cat);

  String? validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  Future<void> onSave() async {
    if (!formKey.currentState!.validate()) return;
    isSaving(true);
    try {
      String? savedImageDirectory;
      if (productImage.value != null) {
        savedImageDirectory = await ImageUtils.saveProductImage(
          productImage.value!,
        );
      }
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
            ? ''
            : descController.text.trim(),
        image: savedImageDirectory ?? '',
        isProductActive: isActive.value,
      );
      await _repository.create(entity);
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

  Future<void> onUpdate() async {
    if (!formKey.currentState!.validate()) return;
    isSaving(true);
    try {
      String? savedImageDirectory;
      if (productImage.value != null) {
        savedImageDirectory = await ImageUtils.saveProductImage(
          productImage.value!,
        );
      }
      final entity = ProductEntity(
        id: product!.id,
        name: nameController.text.trim(),
        sku: skuController.text.trim().isEmpty
            ? 'SKU-${DateTime.now().millisecondsSinceEpoch}'
            : skuController.text.trim(),
        category: selectedCategory.value,
        purchasePrice: double.tryParse(purchasePriceController.text) ?? 0,
        sellingPrice: double.tryParse(priceController.text) ?? 0,
        stock: int.tryParse(stockController.text) ?? 0,
        description: descController.text.trim().isEmpty
            ? ''
            : descController.text.trim(),
        image: savedImageDirectory ?? '',
        isProductActive: isActive.value,
      );
      await _repository.update(entity);
      // Get.back(result: true);

      Get.until((route) => route.settings.name == Routes.PRODUCT_LIST);
      Get.find<ProductListController>().refresh();
      Get.snackbar(
        'Success',
        'Product Updated!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not update product.',
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
    productImage.close();
    selectedCategory.close();
    super.onClose();
  }

  void onAddImage() async {
    final picked = await ImageUtils.pickImageFromGallery();
    if (picked != null) productImage(File(picked.path));
  }

  void toggleProduct() {
    isActive.value = !isActive.value;
  }
}
