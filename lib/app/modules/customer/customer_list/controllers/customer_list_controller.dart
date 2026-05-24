import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class CustomerListController extends GetxController {
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final totalCustomers = 128;
  final totalOverdue = r'$14,240';
  final allCustomers = <Map<String, dynamic>>[
    {
      'initials': 'JD',
      'name': 'Jane Doe',
      'phone': '+1 (555) 012-3456',
      'lastInvoice': 'Oct 24, 2023',
      'status': 'Active Account',
      'due': r'$1,250.00',
      'hasOverdue': true
    },
    {
      'initials': 'MS',
      'name': 'Marcus Smith',
      'phone': '+1 (555) 987-6543',
      'lastInvoice': 'Nov 02, 2023',
      'status': 'New Contract',
      'due': r'$0.00',
      'hasOverdue': false
    },
    {
      'initials': 'AL',
      'name': 'Aria Lopez',
      'phone': '+1 (555) 246-8101',
      'lastInvoice': 'Oct 15, 2023',
      'status': 'Overdue 14 Days',
      'due': r'$3,420.50',
      'hasOverdue': true
    },
    {
      'initials': 'DC',
      'name': 'David Chen',
      'phone': '+1 (555) 777-8888',
      'lastInvoice': 'Oct 30, 2023',
      'status': 'VIP Customer',
      'due': r'$0.00',
      'hasOverdue': false
    },
    {
      'initials': 'SK',
      'name': 'Sarah K.',
      'phone': '+1 (555) 121-2121',
      'lastInvoice': 'Sep 12, 2023',
      'status': 'Inactive (30d+)',
      'due': r'$450.00',
      'hasOverdue': true
    },
  ].obs;

  List<Map<String, dynamic>> get filtered {
    final q = searchQuery.value.toLowerCase();
    if (q.isEmpty) return allCustomers;
    return allCustomers
        .where((c) =>
            (c['name'] as String).toLowerCase().contains(q) ||
            (c['phone'] as String).contains(q))
        .toList();
  }

  void onSearch(String v) => searchQuery(v);

  void onCustomerTap(Map<String, dynamic> c) =>
      Get.toNamed(Routes.CUSTOMER_DETAILS, arguments: c);

  void onAddCustomer() {
    Get.toNamed(Routes.ADD_CUSTOMER);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
