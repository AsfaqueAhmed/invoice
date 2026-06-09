import 'package:flutter/material.dart';
import 'package:flutter_getx_app/core/utils/currency_formatter.dart';
import 'package:flutter_getx_app/features/customer/domain/repositories/customer_repository.dart';
import 'package:get/get.dart';

import '../../domain/repositories/invoice_repository.dart';

class InvoiceListController extends GetxController {
  final InvoiceRepository _invoiceRepository;
  final CustomerRepository _customerRepository;

  InvoiceListController(this._invoiceRepository, this._customerRepository);

  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'All'.obs;
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> _allInvoices =
      <Map<String, dynamic>>[].obs;

  static const filters = ['All', 'Paid', 'Pending', 'Overdue', 'Partial'];

  String get totalReceivable {
    final total =
        _allInvoices.fold<double>(0, (s, i) => s + (i['due'] as double));
    return CurrencyFormatter.format(total);
  }

  String get collectedMTD {
    final total =
        _allInvoices.fold<double>(0, (s, i) => s + (i['paid'] as double));
    return CurrencyFormatter.format(total);
  }

  List<Map<String, dynamic>> get filtered {
    var list = _allInvoices.toList();
    final f = selectedFilter.value.toLowerCase();
    if (f != 'all') list = list.where((i) => i['status'] == f).toList();
    final q = searchQuery.value.toLowerCase().trim();
    if (q.isNotEmpty) {
      list = list.where((i) {
        return (i['number'] as String).toLowerCase().contains(q) ||
            (i['client'] as String).toLowerCase().contains(q);
      }).toList();
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
        return <String, dynamic>{
          'number': inv.invoiceNo,
          'client': customer?.name ?? 'Unknown',
          'amount': CurrencyFormatter.format(inv.total),
          'date': inv.invoiceNo,
          'status': inv.status,
          'tag': inv.due > 0
              ? 'Due: ${CurrencyFormatter.format(inv.due)}'
              : 'Cleared',
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

  @override
  Future<void> refresh() => loadData();

  void onSearch(String v) => searchQuery(v);
  void onFilter(String f) => selectedFilter(f);

  void onCreateInvoice() => Get.toNamed('/create-invoice');
  void onInvoiceTap(Map<String, dynamic> inv) =>
      Get.toNamed('/invoice-details', arguments: inv);

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
