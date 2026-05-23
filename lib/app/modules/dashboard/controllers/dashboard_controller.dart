import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../models/dashboard_summary.dart';

class DashboardController extends GetxController {
  final List<DashboardSummary> summaries = const [
    DashboardSummary(
      label: 'Today Sales',
      value: '\$12,480.00',
      detail: '+12% from yesterday',
      valueColor: AppColors.primary,
      trend: '+12% from yesterday',
      trendIcon: Icons.trending_up_rounded,
    ),
    DashboardSummary(
      label: 'Due Amount',
      value: '\$3,240.00',
      detail: '8 invoices pending',
      valueColor: AppColors.error,
    ),
    DashboardSummary(
      label: 'Collected',
      value: '\$45,000.00',
      detail: 'This month',
      valueColor: AppColors.primary,
    ),
    DashboardSummary(
      label: 'Total Invoices',
      value: '128',
      detail: 'All time',
      valueColor: AppColors.grey900,
    ),
  ];

  final List<DashboardAction> actions = const [
    DashboardAction(
      label: 'New Invoice',
      icon: Icons.add_circle_outline_rounded,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
    ),
    DashboardAction(
      label: 'New Customer',
      icon: Icons.person_add_alt_1_rounded,
      backgroundColor: Color(0xFFD3E4FE),
      foregroundColor: Color(0xFF0B1C30),
    ),
    DashboardAction(
      label: 'Add Product',
      icon: Icons.inventory_2_outlined,
      backgroundColor: Color(0xFFE7E7F3),
      foregroundColor: AppColors.grey700,
    ),
    DashboardAction(
      label: 'Collect Payment',
      icon: Icons.payments_outlined,
      backgroundColor: Color(0xFFFFDBCD),
      foregroundColor: Color(0xFF360F00),
    ),
  ];

  final List<RecentInvoice> recentInvoices = const [
    RecentInvoice(
      number: '#INV-8821',
      customerName: 'Acme Corp Ltd.',
      amount: '\$1,240.00',
      status: 'Paid',
    ),
    RecentInvoice(
      number: '#INV-8822',
      customerName: 'Global Tech Inc.',
      amount: '\$450.00',
      status: 'Pending',
    ),
    RecentInvoice(
      number: '#INV-8823',
      customerName: 'Sarah Jenkins',
      amount: '\$3,100.00',
      status: 'Overdue',
    ),
  ];

  void openInvoices() => Get.toNamed(Routes.invoices);

  void openCreateInvoice() => Get.toNamed(Routes.createInvoice);

  void onQuickAction(String label) {
    if (label == 'New Invoice') {
      openCreateInvoice();
      return;
    }

    Get.snackbar(
      label,
      '$label flow is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onNavTapped(String destination) {
    if (destination == 'Home') return;

    if (destination == 'Invoices') {
      openInvoices();
      return;
    }

    if (destination == 'Customers') {
      Get.toNamed(Routes.CUSTOMER_LIST);
      return;
    }

    if (destination == 'Products') {
      Get.toNamed(Routes.PRODUCT_LIST);
      return;
    }

    Get.snackbar(
      destination,
      '$destination module is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
