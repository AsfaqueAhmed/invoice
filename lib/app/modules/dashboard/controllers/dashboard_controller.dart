import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../models/dashboard_summary.dart';

class DashboardController extends GetxController {
  final RxString todaySales = r'$12,480.00'.obs;
  final RxString dueAmount = r'$3,240.00'.obs;
  final RxString collected = r'$45,000.00'.obs;
  final RxInt totalInvoices = 128.obs;
  final RxBool isLoading = false.obs;

  final recentInvoices = <Map<String, String>>[
    {
      'number': '#INV-8821',
      'client': 'Acme Corp Ltd.',
      'amount': r'$1,240.00',
      'status': 'paid'
    },
    {
      'number': '#INV-8822',
      'client': 'Global Tech Inc.',
      'amount': r'$450.00',
      'status': 'pending'
    },
    {
      'number': '#INV-8823',
      'client': 'Sarah Jenkins',
      'amount': r'$3,100.00',
      'status': 'overdue'
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading(true);
    await Future.delayed(const Duration(milliseconds: 600));
    isLoading(false);
  }

  void onNewInvoice() => Get.toNamed(Routes.createInvoice);

  void onNewCustomer() => Get.toNamed(Routes.ADD_CUSTOMER);

  void onAddProduct() => Get.toNamed(Routes.ADD_PRODUCT);

  void onCollectPayment() {
    Get.toNamed(Routes.ADD_PAYMENT);
  }

  void onSeeAllInvoices() => Get.toNamed(Routes.invoices);

  void onInvoiceTap(Map<String, String> inv) =>
      Get.toNamed(Routes.invoiceDetails, arguments: inv);
}
