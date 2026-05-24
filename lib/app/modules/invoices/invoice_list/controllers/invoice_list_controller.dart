import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class InvoiceListController extends GetxController {
  final searchController = TextEditingController();
  final RxString selectedFilter = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final filters = ['All', 'Paid', 'Partial', 'Due', 'Overdue'];
  final totalReceivable = r'$42,850.00';
  final collectedMTD = r'$12,400.00';
  final allInvoices = <Map<String, dynamic>>[
    {
      'number': '1023',
      'client': 'Alex Thompson',
      'date': '24 Oct 2023',
      'amount': r'$1,250.00',
      'status': 'paid',
      'tag': 'Product Design'
    },
    {
      'number': '1022',
      'client': 'Global Tech Corp',
      'date': '22 Oct 2023',
      'amount': r'$5,400.00',
      'status': 'partial',
      'tag': 'Cloud Migration'
    },
    {
      'number': '1021',
      'client': 'Sarah Jenkins',
      'date': '18 Oct 2023',
      'amount': r'$850.00',
      'status': 'due',
      'tag': 'Branding Suite'
    },
    {
      'number': '1019',
      'client': 'Marcus Webb',
      'date': '05 Oct 2023',
      'amount': r'$2,100.00',
      'status': 'overdue',
      'tag': 'Marketing Strategy'
    },
  ].obs;

  List<Map<String, dynamic>> get filtered {
    var list = allInvoices.where((i) {
      final q = searchQuery.value.toLowerCase();
      return q.isEmpty ||
          (i['client'] as String).toLowerCase().contains(q) ||
          (i['number'] as String).contains(q);
    }).toList();
    if (selectedFilter.value != 'All') {
      list = list
          .where((i) => i['status'] == selectedFilter.value.toLowerCase())
          .toList();
    }
    return list;
  }

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
