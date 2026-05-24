import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bar.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bottom_nav.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/core/widgets/app_user_avatar.dart';
import 'package:flutter_getx_app/app/core/widgets/status_badge.dart';
import 'package:flutter_getx_app/app/modules/customer/customer_list/model/customer_model.dart';
import 'package:flutter_getx_app/app/modules/product/product_details/views/widgets/app_section_header.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/customer_details_controller.dart';

class CustomerDetailsView extends GetView<CustomerDetailsController> {
  const CustomerDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: isDark ? AppColor.darkSurface : AppColor.surface,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: cs.primary),
                onPressed: Get.back),
            title: Text('InvoiceFlow',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: cs.primary)),
            actions: [
              IconButton(
                  icon: Icon(Icons.edit_outlined, color: cs.secondary),
                  onPressed: () {})
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header
                  Row(children: [
                    Stack(children: [
                      Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.primaryFixed,
                              border: Border.all(color: cs.surface, width: 3),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 12)
                              ]),
                          child: Center(
                              child: Text(
                                  (controller.customer['initials'] ??
                                      controller.customer['name']
                                          ?.toString()
                                          .substring(0, 2)
                                          .toUpperCase() ??
                                      'CU'),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: cs.primary)))),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: cs.primaryContainer,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: cs.surface, width: 2)),
                              child: Icon(Icons.verified_rounded,
                                  size: 14, color: cs.onPrimaryContainer))),
                    ]),
                    const SizedBox(width: 16),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(controller.customer['name'] ?? 'Customer',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Row(children: [
                            Icon(Icons.phone_outlined,
                                size: 14, color: cs.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(controller.customer['phone'] ?? '',
                                style: TextStyle(
                                    color: cs.onSurfaceVariant, fontSize: 13))
                          ]),
                          const SizedBox(height: 2),
                          Row(children: [
                            Icon(Icons.location_on_outlined,
                                size: 14, color: cs.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text('San Francisco, CA',
                                style: TextStyle(
                                    color: cs.onSurfaceVariant, fontSize: 13))
                          ]),
                        ])),
                  ]),
                  const SizedBox(height: 20),
                  // Financial Summary
                  AppCard(
                      child: Column(children: [
                    _finRow(Icons.shopping_bag_outlined, cs.onSurfaceVariant,
                        'Total Purchases', controller.totalPurchases, cs),
                    Divider(
                        height: 20, color: cs.outlineVariant.withOpacity(0.5)),
                    _finRow(
                        Icons.check_circle_outline_rounded,
                        AppColor.successText,
                        'Total Paid',
                        controller.totalPaid,
                        cs),
                    Divider(
                        height: 20, color: cs.outlineVariant.withOpacity(0.5)),
                    _finRow(Icons.pending_actions_outlined, cs.primary,
                        'Total Due', controller.totalDue, cs,
                        valueColor: cs.primary),
                  ])),
                  const SizedBox(height: 20),
                  // Quick actions
                  const Text('Quick Actions',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                        child: OutlinedButton.icon(
                            onPressed: controller.onCall,
                            icon: const Icon(Icons.call_outlined, size: 18),
                            label: const Text('Call'),
                            style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 52),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14))))),
                    const SizedBox(width: 10),
                    Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                            onPressed: controller.onNewInvoice,
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('New Invoice'),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 52),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14))))),
                    const SizedBox(width: 10),
                    Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                            onPressed: controller.onCollectPayment,
                            icon: const Icon(Icons.payments_outlined, size: 18),
                            label: const Text('Collect'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: cs.secondaryContainer,
                                foregroundColor: cs.onSecondaryContainer,
                                minimumSize: const Size(0, 52),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14))))),
                  ]),
                  const SizedBox(height: 24),
                  // Invoice history
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Invoice History',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                        TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward_rounded,
                                size: 14),
                            label: const Text('View All')),
                      ]),
                  const SizedBox(height: 8),
                  ...controller.invoices.map(
                    (inv) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppCard(
                        onTap: () => controller.onInvoiceTap(inv),
                        child: Row(
                          children: [
                            Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                    color: cs.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Icon(Icons.description_outlined,
                                    color: cs.secondary)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(inv['number'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                  Text(inv['date'],
                                      style: TextStyle(
                                          color: cs.onSurfaceVariant,
                                          fontSize: 12)),
                                ])),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(inv['amount'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                                const SizedBox(height: 4),
                                StatusBadge(
                                  status: StatusBadge.fromString(
                                    inv['status'],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _finRow(IconData icon, Color iconColor, String label, String value,
          ColorScheme cs,
          {Color? valueColor}) =>
      Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(),
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: cs.secondary,
                        letterSpacing: 0.8)),
                Text(value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: valueColor ?? cs.onSurface)),
              ],
            ),
          ),
        ],
      );
}
