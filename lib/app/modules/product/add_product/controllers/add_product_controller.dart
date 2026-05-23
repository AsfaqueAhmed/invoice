import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/modules/product/product_list/model/product_model.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
final TextEditingController productNameCtrl=TextEditingController();
final TextEditingController stockQtyCtrl=TextEditingController();
final TextEditingController priceCtrl=TextEditingController();
final TextEditingController skuCtrl=TextEditingController();
final TextEditingController descriptionCtrl=TextEditingController();
final Rx<ProductCategory?> selectedCategory = Rx<ProductCategory?>(null);
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    productNameCtrl.dispose();
    stockQtyCtrl.dispose();
    priceCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }

  void addProduct() {}
}
