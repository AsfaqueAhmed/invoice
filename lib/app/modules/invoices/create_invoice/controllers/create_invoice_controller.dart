import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/modules/invoices/create_invoice/views/widgets/select_customer_bottom_sheet.dart';
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
      'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

  final items = <Map<String, dynamic>>[
    {'name': 'Consulting Services', 'sku': 'CS-001', 'qty': 2, 'rate': 150.0},
    {
      'name': 'Premium Support Package',
      'sku': 'PSP-24',
      'qty': 1,
      'rate': 1200.0
    },
  ].obs;

  late final CustomerLocalDatasource _customerDs;
  late final InvoiceLocalDatasource _invoiceDs;
  late final InvoiceItemLocalDatasource _itemDs;

  double get subtotal =>
      items.fold(0.0, (s, i) => s + (i['qty'] as int) * (i['rate'] as double));

  double get grandTotal => subtotal * (1 - discount.value / 100);

  double get dueAmount =>
      (grandTotal - amountPaid.value).clamp(0, double.infinity);

  @override
  void onInit() {
    super.onInit();
    final db = DatabaseService();
    _customerDs = CustomerLocalDatasource();
    _invoiceDs = InvoiceLocalDatasource(db);
    _itemDs = InvoiceItemLocalDatasource(db);
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      customers.value = await _customerDs.getAll();
      log('customers length => ${customers.length}');
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
      for (final item in items) {
        await _itemDs.create(InvoiceItemEntity(
          id: const Uuid().v4(),
          invoiceId: id,
          productId: '',
          name: item['name'],
          qty: item['qty'],
          price: item['rate'],
          total: item['qty'] * item['rate'],
        ));
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

  onAddProduct() {}
}
