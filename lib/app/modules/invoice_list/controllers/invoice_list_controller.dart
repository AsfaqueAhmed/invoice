import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/invoice_item.dart';

class InvoiceListController extends GetxController {
  final searchController = TextEditingController();

  final RxString selectedFilter = 'All'.obs;
  final RxString query = ''.obs;

  final List<String> filters = const [
    'All',
    'Paid',
    'Partial',
    'Due',
    'Overdue',
  ];

  final List<InvoiceItem> invoices = const [
    InvoiceItem(
      number: '#1023',
      date: '24 Oct 2023',
      customerName: 'Alex Thompson',
      projectName: 'Product Design',
      amount: 1250,
      status: InvoiceStatus.paid,
      trailingAction: 'Share',
      trailingIcon: Icons.ios_share_rounded,
    ),
    InvoiceItem(
      number: '#1022',
      date: '22 Oct 2023',
      customerName: 'Global Tech Corp',
      projectName: 'Cloud Migration',
      amount: 5400,
      status: InvoiceStatus.partial,
      trailingAction: 'PDF',
      trailingIcon: Icons.picture_as_pdf_rounded,
    ),
    InvoiceItem(
      number: '#1021',
      date: '18 Oct 2023',
      customerName: 'Sarah Jenkins',
      projectName: 'Branding Suite',
      amount: 850,
      status: InvoiceStatus.due,
      trailingAction: 'Share',
      trailingIcon: Icons.ios_share_rounded,
    ),
    InvoiceItem(
      number: '#1019',
      date: '05 Oct 2023',
      customerName: 'Marcus Webb',
      projectName: 'Marketing Strategy',
      amount: 2100,
      status: InvoiceStatus.overdue,
      trailingAction: 'Remind',
      trailingIcon: Icons.mail_outline_rounded,
    ),
  ];

  List<InvoiceItem> get filteredInvoices {
    final normalizedQuery = query.value.trim().toLowerCase();
    final filter = selectedFilter.value.toLowerCase();

    return invoices.where((invoice) {
      final matchesFilter =
          filter == 'all' || invoice.status.name.toLowerCase() == filter;
      final matchesQuery = normalizedQuery.isEmpty ||
          invoice.number.toLowerCase().contains(normalizedQuery) ||
          invoice.customerName.toLowerCase().contains(normalizedQuery);

      return matchesFilter && matchesQuery;
    }).toList();
  }

  double get totalReceivable =>
      invoices.fold(0, (total, invoice) => total + invoice.amount);

  double get collectedMonthToDate => invoices
      .where((invoice) => invoice.status == InvoiceStatus.paid)
      .fold(0, (total, invoice) => total + invoice.amount);

  void updateSearch(String value) => query(value);

  void selectFilter(String filter) => selectedFilter(filter);

  void openFilterSheet() {
    Get.bottomSheet<void>(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter invoices',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...filters.map(
                (filter) => Obx(
                  () => RadioListTile<String>(
                    value: filter,
                    groupValue: selectedFilter.value,
                    onChanged: (value) {
                      if (value != null) {
                        selectFilter(value);
                        Get.back<void>();
                      }
                    },
                    title: Text(filter),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }

  void addInvoice() {
    Get.snackbar(
      'New invoice',
      'Invoice creation flow is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onNavTapped(String destination) {
    if (destination == 'Invoices') return;

    Get.snackbar(
      destination,
      '$destination module is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
