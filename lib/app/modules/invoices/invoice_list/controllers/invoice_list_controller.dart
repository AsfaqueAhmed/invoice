import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/extensions/num_extensions.dart';
import '../../../../data/repositories/customer_repository.dart';
import '../../../../data/repositories/invoice_repository.dart';
import '../../../../routes/app_pages.dart';

class InvoiceListController extends GetxController {
  InvoiceListController(this._invoiceRepository, this._customerRepository);

  final InvoiceRepository _invoiceRepository;
  final CustomerRepository _customerRepository;

  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'All'.obs;
  final RxBool isLoading = true.obs;

  final filters = ['All', 'Paid', 'Pending', 'Overdue', 'Partial'];

  final RxList<Map<String, dynamic>> _allInvoices =
      <Map<String, dynamic>>[].obs;

  String get totalReceivable {
    final total = _allInvoices.fold<double>(
        0, (s, i) => s + (i['due'] as double));
    return total.asCurrency;
  }

  String get collectedMTD {
    final total = _allInvoices.fold<double>(
        0, (s, i) => s + (i['paid'] as double));
    return total.asCurrency;
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
    loadData();
  }

  Future<void> loadData() async {
    isLoading(true);
    try {
      final invoices = await _invoiceRepository.getAll();
      final customers = await _customerRepository.getAll();
      final customerMap = {for (final c in customers) c.id: c};

      _allInvoices.value = invoices.map((inv) {
        final customer = customerMap[inv.customerId];
        return {
          'number': inv.invoiceNo,
          'client': customer?.name ?? 'Unknown',
          'amount': inv.total.asCurrency,
          'date': inv.invoiceNo, // placeholder if no date field
          'status': inv.status,
          'tag': inv.due > 0 ? 'Due: ${inv.due.asCurrency}' : 'Cleared',
          'due': inv.due,
          'paid': inv.paid,
          'id': inv.id,
        };
      }).toList();
    } catch (e, stack) {
      debugPrint('Error loading invoices: $e\n$stack');
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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
