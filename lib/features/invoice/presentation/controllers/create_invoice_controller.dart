import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_getx_app/features/customer/domain/models/customer.dart';
import 'package:flutter_getx_app/features/customer/domain/repositories/customer_repository.dart';
import 'package:flutter_getx_app/features/invoice/domain/models/cart_item.dart';
import 'package:flutter_getx_app/features/invoice/domain/models/invoice.dart';
import 'package:flutter_getx_app/features/invoice/domain/models/invoice_item.dart';
import 'package:flutter_getx_app/features/product/domain/models/product.dart';
import 'package:flutter_getx_app/features/product/domain/repositories/product_repository.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/invoice_repository.dart';
import 'invoice_list_controller.dart';

class CreateInvoiceController extends GetxController {
  final InvoiceRepository _invoiceRepository;
  final CustomerRepository _customerRepository;
  final ProductRepository _productRepository;

  CreateInvoiceController(
    this._invoiceRepository,
    this._customerRepository,
    this._productRepository,
  );

  final searchController = TextEditingController();
  final Rx<Customer?> selectedCustomer = Rx(null);
  final RxList<Customer> customers = <Customer>[].obs;
  final RxList<Product> products = <Product>[].obs;
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxDouble discount = 10.0.obs;
  final RxDouble amountPaid = 0.0.obs;
  final RxBool isSaving = false.obs;

  String get invoiceNo =>
      'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

  double get subtotal => cartItems.fold(0.0, (s, item) => s + item.lineTotal);

  double get grandTotal => subtotal * (1 - discount.value / 100);

  double get dueAmount =>
      (grandTotal - amountPaid.value).clamp(0, double.infinity);

  @override
  void onInit() {
    super.onInit();
    _loadCustomers();
    _loadProducts();
  }

  Future<void> loadCustomers() => _loadCustomers();
  Future<void> loadProducts() => _loadProducts();

  Future<void> _loadCustomers() async {
    try {
      customers.value = await _customerRepository.getAll();
      log('customers loaded: ${customers.length}');
    } catch (_) {}
  }

  Future<void> _loadProducts() async {
    try {
      products.value = await _productRepository.getAll();
    } catch (_) {}
  }

  void onCustomerSelected(Customer c) {
    selectedCustomer.value = c;
    Get.back();
  }

  void onProductSelected(Product p) {
    final already = cartItems.any((i) => i.product.id == p.id);
    if (!already) {
      cartItems.add(CartItem(product: p, quantity: 1));
      Get.back();
    } else {
      Get.snackbar('Warning', 'Product already added.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void incrementQty(int idx) {
    final item = cartItems[idx];
    cartItems[idx] = item.copyWith(quantity: item.quantity + 1);
  }

  void decrementQty(int idx) {
    final item = cartItems[idx];
    if (item.quantity == 1) {
      removeItem(idx);
      return;
    }
    cartItems[idx] = item.copyWith(quantity: item.quantity - 1);
  }

  void removeItem(int idx) => cartItems.removeAt(idx);

  Future<void> onSave() async {
    if (selectedCustomer.value == null) {
      Get.snackbar('Missing', 'Please select a customer.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (cartItems.isEmpty) {
      Get.snackbar('Missing', 'Please add at least one item.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isSaving(true);
    try {
      final id = const Uuid().v4();
      final invoice = Invoice(
        id: id,
        customerId: selectedCustomer.value!.id,
        invoiceNo: invoiceNo,
        subtotal: subtotal,
        discount: discount.value,
        tax: 0,
        total: grandTotal,
        paid: amountPaid.value,
        due: dueAmount,
        status: dueAmount <= 0
            ? 'paid'
            : amountPaid.value > 0
                ? 'partial'
                : 'pending',
      );
      await _invoiceRepository.create(invoice);
      for (final item in cartItems) {
        await _invoiceRepository.createItem(InvoiceItem(
          id: const Uuid().v4(),
          invoiceId: id,
          productId: item.product.id,
          name: item.product.name,
          qty: item.quantity,
          price: item.product.sellingPrice,
          total: item.lineTotal,
        ));
      }

      if (Get.isRegistered<InvoiceListController>()) {
        Get.find<InvoiceListController>().loadData();
      }

      Get.back(result: true);
      Get.snackbar('Success', 'Invoice saved!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('Error', 'Could not save invoice.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving(false);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
