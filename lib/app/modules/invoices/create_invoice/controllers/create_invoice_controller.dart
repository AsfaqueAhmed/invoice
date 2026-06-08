import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/extensions/string_extensions.dart';
import 'package:flutter_getx_app/app/data/entities/product_entity.dart';
import 'package:flutter_getx_app/app/modules/invoices/create_invoice/views/widgets/select_customer_bottom_sheet.dart';
import 'package:flutter_getx_app/app/modules/invoices/invoice_list/controllers/invoice_list_controller.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/entities/customer_entity.dart';
import '../../../../data/entities/invoice_entity.dart';
import '../../../../data/entities/invoice_item_entity.dart';
import '../../../../data/repositories/customer_repository.dart';
import '../../../../data/repositories/invoice_repository.dart';
import '../../../../data/repositories/product_repository.dart';

class CreateInvoiceController extends GetxController {
  CreateInvoiceController(
    this._customerRepository,
    this._productRepository,
    this._invoiceRepository,
  );

  final CustomerRepository _customerRepository;
  final ProductRepository _productRepository;
  final InvoiceRepository _invoiceRepository;

  final searchController = TextEditingController();
  Rx<CustomerEntity?> selectedCustomer = Rx(null);

  final RxString searchQuery = ''.obs;
  final RxDouble discount = 10.0.obs;
  final RxDouble amountPaid = 0.0.obs;
  final RxBool isSaving = false.obs;

  final RxList<CustomerEntity> customers = <CustomerEntity>[].obs;

  String get invoiceNo =>
      'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

  double get subtotal =>
      items.fold(0.0, (s, i) => s + ((i.quantity ?? 0)) * (i.sellingPrice));

  double get grandTotal => subtotal * (1 - discount.value / 100);

  double get dueAmount =>
      (grandTotal - amountPaid.value).clamp(0, double.infinity);

  RxList<ProductEntity> products = <ProductEntity>[].obs;

  RxList<ProductEntity> items = <ProductEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCustomers();
    _loadProducts();
  }

  Future<void> _loadCustomers() async {
    try {
      customers.value = await _customerRepository.getAll();
    } catch (e) {
      debugPrint('Error loading customers: $e');
    }
  }

  Future<void> _loadProducts() async {
    try {
      products.value = await _productRepository.getAll();
    } catch (e) {
      debugPrint('Error loading products: $e');
    }
  }

  void onSelectCustomer() {
    if (customers.isEmpty) return;
    Get.bottomSheet(
      Obx(() {
        return AppSelectBottomSheet<CustomerEntity>(
          title: "Select Customer",
          items: customers.value,
          selectedItem: selectedCustomer.value,
          onSelect: (c) {
            selectedCustomer.value = c;
            Get.back();
          },
          addTitle: "Add New Customer",
          addSubtitle: "Create a profile for a new client",
          onAddTap: () async {
            await Get.toNamed(Routes.ADD_CUSTOMER);
            await _loadCustomers();
          },
          titleBuilder: (c) => c.name,
          subtitleBuilder: (c) => c.phone,
          avatarBuilder: (c) => c.name.initials,
        );
      }),
      isScrollControlled: true,
    );
  }

  void onSelectProduct() {
    if (products.isEmpty) return;
    Get.bottomSheet(
      Obx(() {
        return AppSelectBottomSheet<ProductEntity>(
          title: "Select Product",
          items: products.value,
          selectedItem: null,
          onSelect: (c) {
            final existingItem = items.firstWhereOrNull((i) => i.id == c.id);
            if (existingItem == null) {
              c.quantity = 1;
              items.add(c);
              Get.back();
            } else {
              Get.snackbar('Warning', 'Product already added.',
                  snackPosition: SnackPosition.BOTTOM);
            }
          },
          addTitle: "Add Product",
          addSubtitle: "Update invoice by adding this product",
          onAddTap: () async {
            await Get.toNamed(Routes.ADD_PRODUCT);
            await _loadProducts();
          },
          titleBuilder: (c) => c.name,
          subtitleBuilder: (c) => '${c.category} | ${c.sku} | qty:${c.stock}',
          filePathBuilder: (c) => c.image.notNullNotEmpty ? c.image! : '',
          avatarBuilder: (c) => c.name.initials.isEmpty ? 'U' : c.name.initials,
        );
      }),
      isScrollControlled: true,
    );
  }

  void incrementQty(int idx) {
    final item = items[idx];
    item.quantity = (item.quantity ?? 0) + 1;
    items[idx] = item;
  }

  void decrementQty(int idx) {
    final item = items[idx];
    if (item.quantity == 1) {
      removeItem(idx);
      return;
    }
    item.quantity = (item.quantity ?? 0) - 1;
    items[idx] = item;
  }

  void removeItem(int idx) => items.removeAt(idx);

  Future<void> onSave() async {
    if (selectedCustomer.value == null) {
      Get.snackbar('Missing', 'Please select a customer.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (items.isEmpty) {
      Get.snackbar('Missing', 'Please add at least one item.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isSaving(true);
    try {
      final id = const Uuid().v4();
      final invoice = InvoiceEntity(
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
      final invoiceItems = items
          .map((item) => InvoiceItemEntity(
                id: const Uuid().v4(),
                invoiceId: id,
                productId: item.id,
                name: item.name,
                qty: item.quantity ?? 0,
                price: item.sellingPrice,
                total: (item.quantity ?? 0) * item.sellingPrice,
              ))
          .toList();
      await _invoiceRepository.createInvoiceWithItems(invoice, invoiceItems);

      if (Get.isRegistered<InvoiceListController>()) {
        Get.find<InvoiceListController>().loadData();
      }

      Get.back(result: true);
      Get.snackbar('Success', 'Invoice saved!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      debugPrint('Error saving invoice: $e');
      Get.snackbar('Error', 'Could not save invoice.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving(false);
    }
  }

  void onSearch(String value) => searchQuery(value);

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
