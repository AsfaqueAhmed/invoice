import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/modules/customer/customer_list/model/customer_model.dart';
import 'package:flutter_getx_app/app/modules/customer/customer_list/views/widgets/app_avatar.dart';
import 'package:flutter_getx_app/app/modules/customer/customer_list/views/widgets/app_search_bar.dart';
import 'package:flutter_getx_app/app/modules/product/product_list/views/widgets/app_status_chip.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/customer_list_controller.dart';

class CustomerListView extends GetView<CustomerListController> {
  const CustomerListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: AppSearchBar(
                hint: 'Search by name or phone...',
                onChanged: (v) => controller.searchQuery.value = v,
              ),
            ),
            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => _StatsRow(
                totalCustomers: controller.totalCustomers,
                totalOverdue: controller.totalOverdue,
                pendingCount: controller.pendingCount,
              )),
            ),
            const SizedBox(height: 16),
            // Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active Customers',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.tune_rounded,
                            size: 14, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Customer List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary));
                }
                if (controller.filteredCustomers.isEmpty) {
                  return const Center(
                    child: Text(
                      'No customers found',
                      style: TextStyle(
                          fontFamily: 'DMSans',
                          color: AppColors.textSecondary),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: controller.filteredCustomers.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
                  itemBuilder: (ctx, i) {
                    final customer = controller.filteredCustomers[i];
                    return _CustomerCard(
                      customer: customer,
                      onTap: () => controller.selectCustomer(customer),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_CUSTOMER),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
class _StatsRow extends StatelessWidget {
  final int totalCustomers;
  final double totalOverdue;
  final int pendingCount;

  const _StatsRow({
    required this.totalCustomers,
    required this.totalOverdue,
    required this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'TOTAL CUSTOMERS',
            value: '$totalCustomers',
            badge: '+2% this month',
            badgeColor: AppColors.chipGreen,
            badgeFg: AppColors.chipGreenFg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'TOTAL OVERDUE',
            value: fmt.format(totalOverdue),
            badge: '$pendingCount Pending',
            isOverdue: true,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String badge;
  final Color? badgeColor;
  final Color? badgeFg;
  final bool isOverdue;

  const _StatCard({
    required this.label,
    required this.value,
    required this.badge,
    this.badgeColor,
    this.badgeFg,
    this.isOverdue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color:
              isOverdue ? AppColors.overdue : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor ?? AppColors.chipRed,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: badgeFg ?? AppColors.chipRedFg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback onTap;

  const _CustomerCard({required this.customer, required this.onTap});

  Color get _avatarColor {
    switch (customer.status) {
      case CustomerStatus.active:
        return AppColors.primary;
      case CustomerStatus.newContract:
        return const Color(0xFF06B6D4);
      case CustomerStatus.overdue:
        return AppColors.overdue;
      case CustomerStatus.vip:
        return const Color(0xFF8B5CF6);
      case CustomerStatus.inactive:
        return AppColors.textTertiary;
    }
  }

  (Color, Color) get _chipColors {
    switch (customer.status) {
      case CustomerStatus.active:
        return (AppColors.chipBlue, AppColors.chipBlueFg);
      case CustomerStatus.newContract:
        return (const Color(0xFFECFEFF), const Color(0xFF0891B2));
      case CustomerStatus.overdue:
        return (AppColors.chipRed, AppColors.chipRedFg);
      case CustomerStatus.vip:
        return (
        const Color(0xFFF5F3FF),
        const Color(0xFF7C3AED)
        );
      case CustomerStatus.inactive:
        return (AppColors.chipGray, AppColors.chipGrayFg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt =
    NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFmt = DateFormat('MMM dd, yyyy');
    final chips = _chipColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                AppAvatar(
                  imageUrl: customer.avatarUrl,
                  initials: customer.initials,
                  color: _avatarColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: const TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        customer.phone,
                        style: const TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert_rounded,
                    color: AppColors.textTertiary, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            // Divider
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 10),
            // Last Invoice & Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LAST INVOICE',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      customer.lastInvoiceDate != null
                          ? dateFmt.format(customer.lastInvoiceDate!)
                          : 'No invoices',
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'DUE AMOUNT',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      fmt.format(customer.totalDue),
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: customer.totalDue > 0
                            ? AppColors.overdue
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Status chip
            AppStatusChip(
              label: customer.status.label,
              bg: chips.$1,
              fg: chips.$2,
            ),
          ],
        ),
      ),
    );
  }
}