import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/create_invoice_item.dart';

class CreateInvoiceController extends GetxController {
  final productSearchController = TextEditingController();
  final discountController = TextEditingController(text: '10');
  final amountPaidController = TextEditingController(text: '500');

  final RxString selectedCustomer = 'Select Customer'.obs;
  final RxList<CreateInvoiceItem> items = <CreateInvoiceItem>[
    const CreateInvoiceItem(
      name: 'Consulting Services',
      sku: 'CS-001',
      unitLabel: 'hr',
      unitPrice: 150,
      quantity: 2,
    ),
    const CreateInvoiceItem(
      name: 'Premium Support Package',
      sku: 'PSP-24',
      unitLabel: 'ea',
      unitPrice: 1200,
      quantity: 1,
    ),
  ].obs;

  double get subtotal => items.fold(0.0, (total, item) => total + item.total);

  double get discountPercent =>
      double.tryParse(discountController.text.trim())?.clamp(0, 100) ?? 0;

  double get discountAmount => subtotal * (discountPercent / 100);

  double get grandTotal => subtotal - discountAmount;

  double get amountPaid =>
      double.tryParse(amountPaidController.text.trim())?.clamp(0, grandTotal) ??
      0;

  double get dueAmount => grandTotal - amountPaid;

  void refreshTotals() => items.refresh();

  void selectCustomer() {
    selectedCustomer('Acme Corp Ltd.');
    Get.snackbar(
      'Customer selected',
      'Acme Corp Ltd. added to this invoice.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void quickAddCustomer() {
    Get.snackbar(
      'New customer',
      'Customer creation flow is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void scanProduct() {
    Get.snackbar(
      'Scanner',
      'QR scanner flow is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateQuantity(int index, int delta) {
    final item = items[index];
    final nextQuantity = (item.quantity + delta).clamp(0, 99);
    items[index] = item.copyWith(quantity: nextQuantity);
  }

  void removeItem(int index) {
    items.removeAt(index);
  }

  void saveInvoice() {
    Get.snackbar(
      'Invoice saved',
      'Invoice draft saved locally for now.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void printInvoice() {
    Get.snackbar(
      'Print',
      'Print flow is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void shareInvoice() {
    Get.snackbar(
      'Share',
      'Share flow is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    productSearchController.dispose();
    discountController.dispose();
    amountPaidController.dispose();
    super.onClose();
  }
}
