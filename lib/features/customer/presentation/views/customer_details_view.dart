import 'package:flutter/material.dart';
import 'package:flutter_getx_app/core/extensions/string_extensions.dart';
import 'package:get/get.dart';

import 'package:flutter_getx_app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/core/constants/gaps.dart';
import 'package:flutter_getx_app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/core/widgets/app_bottom_nav.dart';
import 'package:flutter_getx_app/core/widgets/status_badge.dart';
import '../controllers/customer_details_controller.dart';

class CustomerDetailsView extends GetView<CustomerDetailsController> {
  const CustomerDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: colors.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
            onPressed: Get.back,
          ),
          title: Text(
            'InvoiceFlow',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: colors.textSecondary),
              onPressed: () {},
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Profile header ───────────────────────────
                Row(children: [
                  Stack(children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primaryContainer,
                        border: Border.all(color: colors.surface, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          controller.customer.name.initials,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.surface, width: 2),
                        ),
                        child: Icon(Icons.verified_rounded,
                            size: 14, color: colors.primary),
                      ),
                    ),
                  ]),
                  Gaps.h16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.customer.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        Gaps.v4,
                        Row(children: [
                          Icon(Icons.phone_outlined,
                              size: 14, color: colors.textSecondary),
                          Gaps.h4,
                          Text(
                            controller.customer.phone,
                            style: TextStyle(
                                color: colors.textSecondary, fontSize: 13),
                          ),
                        ]),
                        Gaps.v2,
                        Row(children: [
                          Icon(Icons.location_on_outlined,
                              size: 14, color: colors.textSecondary),
                          Gaps.h4,
                          Text(
                            controller.customer.address,
                            style: TextStyle(
                                color: colors.textSecondary, fontSize: 13),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ]),

                Gaps.v20,

                // ── Financial Summary ────────────────────────
                AppCard(
                  child: Column(children: [
                    _FinRow(
                      icon: Icons.shopping_bag_outlined,
                      iconColor: colors.textSecondary,
                      label: 'Total Purchases',
                      value: controller.totalPurchases,
                      colors: colors,
                    ),
                    Divider(
                        height: 20,
                        color: colors.outlineVariant.withOpacity(0.5)),
                    _FinRow(
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: colors.chipGreenFg,
                      label: 'Total Paid',
                      value: controller.totalPaid,
                      colors: colors,
                    ),
                    Divider(
                        height: 20,
                        color: colors.outlineVariant.withOpacity(0.5)),
                    _FinRow(
                      icon: Icons.pending_actions_outlined,
                      iconColor: colors.primary,
                      label: 'Total Due',
                      value: controller.totalDue,
                      colors: colors,
                      valueColor: colors.primary,
                    ),
                  ]),
                ),

                Gaps.v20,

                // ── Quick actions ────────────────────────────
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                Gaps.v12,
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.onCall,
                            icon: const Icon(Icons.call_outlined, size: 18),
                            label: const Text('Call'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppDecorations.borderRadiusSM,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.onNewInvoice,
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('New Invoice'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              minimumSize: const Size(0, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppDecorations.borderRadiusSM,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: controller.onCollectPayment,
                        icon: const Icon(Icons.payments_outlined, size: 18),
                        label: const Text('Collect'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.secondaryContainer,
                          foregroundColor: colors.onSecondaryContainer,
                          minimumSize: const Size(0, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppDecorations.borderRadiusSM,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Gaps.v24,

                // ── Invoice history ──────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Invoice History',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                      label: const Text('View All'),
                    ),
                  ],
                ),
                Gaps.v8,
                ...controller.invoices.map(
                  (inv) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      onTap: () => controller.onInvoiceTap(inv),
                      child: Row(children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: AppDecorations.iconContainer(
                            color: colors.surfaceContainerLow,
                            size: 12,
                          ),
                          child: Icon(Icons.description_outlined,
                              color: colors.textSecondary),
                        ),
                        Gaps.h12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                inv['number'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: colors.textPrimary,
                                ),
                              ),
                              Text(
                                inv['date'],
                                style: TextStyle(
                                    color: colors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              inv['amount'],
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: colors.textPrimary,
                              ),
                            ),
                            Gaps.v4,
                            StatusBadge(
                              status: StatusBadge.fromString(inv['status']),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class _FinRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label, value;
  final Color? valueColor;
  final AppColorBase colors;

  const _FinRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.colors,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 44,
        height: 44,
        decoration: AppDecorations.iconContainer(
          color: iconColor.withOpacity(0.1),
          size: 12,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      Gaps.h12,
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: valueColor ?? colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

extension _ColorGaps on Gaps {
  static const Widget v2 = SizedBox(height: 2);
}
