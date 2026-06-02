import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/database/database_service.dart';
import '../../../../data/datasources/local/invoice_local_datasource.dart';
import '../../../../data/datasources/local/customer_local_datasource.dart';
import '../../../../data/entities/invoice_entity.dart';
import '../../../../data/entities/customer_entity.dart';
import '../../../../routes/app_pages.dart';

class InvoiceListController extends GetxController {
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'All'.obs;
  final RxBool isLoading = true.obs;

  final filters = ['All', 'Paid', 'Pending', 'Overdue', 'Partial'];

  final RxList<Map<String, dynamic>> _allInvoices =
      <Map<String, dynamic>>[].obs;

  late final InvoiceLocalDatasource _invoiceDs;
  late final CustomerLocalDatasource _customerDs;

  String get totalReceivable {
    final total = _allInvoices.fold<double>(
        0, (s, i) => s + (i['due'] as double));
    return _fmt(total);
  }

  String get collectedMTD {
    final total = _allInvoices.fold<double>(
        0, (s, i) => s + (i['paid'] as double));
    return _fmt(total);
  }

  List<Map<String, dynamic>> get filtered {
    var list = _allInvoices.toList();
    final f = selectedFilter.value.toLowerCase();
    if (f != 'all') {
      list = list.where((i) => i['status'] == f).toList();
    }
    final q = searchQuery.value.toLowerCase().trim();
    if (q.isNotEmpty) {
      list = list
          .where((i) =>
              (i['number'] as String).toLowerCase().contains(q) ||
              (i['client'] as String).toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    final db = DatabaseService();
    _invoiceDs = InvoiceLocalDatasource(db);
    _customerDs = CustomerLocalDatasource();
    loadData();
  }

  Future<void> loadData() async {
    isLoading(true);
    try {
      final invoices = await _invoiceDs.getAll();
      final customers = await _customerDs.getAll();
      final customerMap = {for (final c in customers) c.id: c};

      _allInvoices.value = invoices.map((inv) {
        final customer = customerMap[inv.customerId];
        return {
          'number': inv.invoiceNo,
          'client': customer?.name ?? 'Unknown',
          'amount': _fmt(inv.total),
          'date': inv.invoiceNo, // placeholder if no date field
          'status': inv.status,
          'tag': inv.due > 0 ? 'Due: ${_fmt(inv.due)}' : 'Cleared',
          'due': inv.due,
          'paid': inv.paid,
          'id': inv.id,
        };
      }).toList();
    } catch (_) {
      _allInvoices.value = [];
    } finally {
      isLoading(false);
    }
  }

  Future<void> refresh() => loadData();

  void onSearch(String v) => searchQuery(v);
  void onFilter(String f) => selectedFilter(f);

  void onCreateInvoice() => Get.toNamed(Routes.createInvoice);
  void onInvoiceTap(Map<String, dynamic> inv) =>
      Get.toNamed(Routes.invoiceDetails, arguments: inv);

  String _fmt(double val) {
    if (val >= 1000) {
      return '\$${val.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    }
    return '\$${val.toStringAsFixed(2)}';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
