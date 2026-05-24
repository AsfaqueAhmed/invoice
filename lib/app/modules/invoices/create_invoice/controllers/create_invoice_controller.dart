import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/create_invoice_item.dart';

class CreateInvoiceController extends GetxController {
  final searchController = TextEditingController();
  final RxString selectedCustomer = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxDouble discount = 10.0.obs;
  final RxDouble amountPaid = 500.0.obs;
  final RxBool isSaving = false.obs;

  final items = <Map<String, dynamic>>[
    {'name': 'Consulting Services', 'sku': 'CS-001', 'qty': 2, 'rate': 150.0},
    {
      'name': 'Premium Support Package',
      'sku': 'PSP-24',
      'qty': 1,
      'rate': 1200.0
    },
  ].obs;

  double get subtotal =>
      items.fold(0.0, (s, i) => s + (i['qty'] as int) * (i['rate'] as double));

  double get grandTotal => subtotal * (1 - discount.value / 100);

  double get dueAmount => grandTotal - amountPaid.value;

  void incrementQty(int idx) {
    final item = Map<String, dynamic>.from(items[idx]);
    item['qty'] = (item['qty'] as int) + 1;
    items[idx] = item;
    items.refresh();
  }

  void decrementQty(int idx) {
    final item = Map<String, dynamic>.from(items[idx]);
    if ((item['qty'] as int) > 1) {
      item['qty'] = (item['qty'] as int) - 1;
      items[idx] = item;
      items.refresh();
    }
  }

  void removeItem(int idx) => items.removeAt(idx);

  Future<void> onSave() async {
    isSaving(true);
    await Future.delayed(const Duration(milliseconds: 1500));
    isSaving(false);
    Get.back();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearch(String value) {
    searchQuery.value = value;
  }
}
