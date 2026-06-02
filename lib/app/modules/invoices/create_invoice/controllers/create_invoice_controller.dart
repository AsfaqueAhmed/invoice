import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/extensions/string_extensions.dart';
import 'package:flutter_getx_app/app/core/services/local_storage_service.dart';
import 'package:flutter_getx_app/app/data/datasources/local/product_local_datasource.dart';
import 'package:flutter_getx_app/app/data/entities/product_entity.dart';
import 'package:flutter_getx_app/app/modules/invoices/create_invoice/views/widgets/select_customer_bottom_sheet.dart';
import 'package:flutter_getx_app/app/modules/invoices/invoice_list/controllers/invoice_list_controller.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_service.dart';
import '../../../../data/datasources/local/customer_local_datasource.dart';
import '../../../../data/datasources/local/invoice_local_datasource.dart';
import '../../../../data/datasources/local/invoice_item_local_datasource.dart';
import '../../../../data/entities/invoice_entity.dart';
import '../../../../data/entities/invoice_item_entity.dart';
import '../../../../data/entities/customer_entity.dart';

class CreateInvoiceController extends GetxController {
  final searchController = TextEditingController();
  Rx<CustomerEntity?> selectedCustomer = Rx(null);

  final RxString searchQuery = ''.obs;
  final RxDouble discount = 10.0.obs;
  final RxDouble amountPaid = 0.0.obs;
  final RxBool isSaving = false.obs;

  final RxList<CustomerEntity> customers = <CustomerEntity>[].obs;

  String get invoiceNo =>
      '${LocalStorageService.invoicePrefix}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

  late final CustomerLocalDatasource _customerDs;
  late final InvoiceLocalDatasource _invoiceDs;
  late final InvoiceItemLocalDatasource _itemDs;
  late final ProductLocalDatasource _productDs;

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
    final db = DatabaseService();
    _customerDs = CustomerLocalDatasource();
    _invoiceDs = InvoiceLocalDatasource(db);
    _itemDs = InvoiceItemLocalDatasource(db);
    _productDs = ProductLocalDatasource(db);
    _loadCustomers();
    _loadProducts();
  }

  Future<void> _loadCustomers() async {
    try {
      customers.value = await _customerDs.getAll();
      log('customers length => ${customers.length}');
    } catch (_) {}
  }

  Future<void> _loadProducts() async {
    try {
      products.value = await _productDs.getAll();
    } catch (_) {}
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
            log('on add tap');
            await Get.toNamed(Routes.ADD_CUSTOMER);
            await _loadCustomers();
          },
          titleBuilder: (c) => c.name,
          subtitleBuilder: (c) => c.phone,
          avatarBuilder: (c) => c.name.isNotEmpty
              ? c.name.trim().split(' ').map((e) => e[0]).take(2).join()
              : 'U',
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
          avatarBuilder: (c) => c.name.notNullNotEmpty
              ? c.name.trim().split(' ').map((e) => e[0]).take(2).join()
              : 'U',
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
      await _invoiceDs.create(invoice);
      for (final item in products) {
        await _itemDs.create(InvoiceItemEntity(
          id: const Uuid().v4(),
          invoiceId: id,
          productId: '',
          name: item.name,
          qty: item.quantity ?? 0,
          price: item.sellingPrice,
          total: (item.quantity ?? 0) * item.sellingPrice,
        ));
      }

      if (Get.isRegistered<InvoiceListController>()) {
        Get.find<InvoiceListController>().loadData();
      }

      Get.back(result: true);
      Get.snackbar('Success', 'Invoice saved!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
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
