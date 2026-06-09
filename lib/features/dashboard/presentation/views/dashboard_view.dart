import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_getx_app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/core/constants/gaps.dart';
import 'package:flutter_getx_app/core/constants/padding.dart';
import 'package:flutter_getx_app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/core/widgets/app_bottom_nav.dart';
import 'package:flutter_getx_app/core/widgets/status_badge.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onNewInvoice,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: colors.surface,
              pinned: true,
              elevation: 0,
              title: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Obx(
                    () {
                      if (controller.businesses.isEmpty) {
                        return Icon(
                          Icons.business_rounded,
                          color: cs.onSecondaryContainer,
                          size: 20,
                        );
                      }
                      final business = controller.businesses.first;
                      return business.logo.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: Image.file(
                                File(business.logo),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.business_rounded,
                              color: cs.onSecondaryContainer,
                              size: 20,
                            );
                    },
                  ),
                ),
                Gaps.h10,
                Text(
                  'InvoiceFlow',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
              ]),
              actions: [
                IconButton(
                  icon:
                      Icon(Icons.notifications_outlined, color: colors.primary),
                  onPressed: () {},
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return SizedBox(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.v8,

                    // ── Summary cards ─────────────────────────
                    SizedBox(
                      height: 132,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: AppPadding.h20 + AppPadding.v12,
                        children: [
                          AppStatCard(
                            label: 'Today Sales',
                            value: controller.todaySales.value,
                            sub: '+12% from yesterday',
                            subIcon: Icons.trending_up_rounded,
                            subColor: colors.tertiary,
                            valueColor: colors.primary,
                            valueSize: 26,
                          ),
                          Gaps.h12,
                          AppStatCard(
                            label: 'Due Amount',
                            value: controller.dueAmount.value,
                            sub: '${controller.totalInvoices.value} invoices',
                            valueColor: colors.error,
                          ),
                          Gaps.h12,
                          AppStatCard(
                            label: 'Collected',
                            value: controller.collected.value,
                            sub: 'All time',
                            valueColor: colors.primary,
                          ),
                          Gaps.h12,
                          AppStatCard(
                            label: 'Total Invoices',
                            value: '${controller.totalInvoices.value}',
                            sub: 'All time',
                          ),
                          Gaps.h20,
                        ],
                      ),
                    ),

                    Gaps.v12,

                    // ── Quick Actions ─────────────────────────
                    Padding(
                      padding: AppPadding.h20,
                      child: Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    Gaps.v12,
                    Padding(
                      padding: AppPadding.h20,
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        padding: EdgeInsets.zero,
                        children: [
                          _QuickAction(
                            icon: Icons.add_circle_outline_rounded,
                            label: 'New Invoice',
                            bg: cs.primaryContainer,
                            fg: cs.onPrimaryContainer,
                            onTap: controller.onNewInvoice,
                          ),
                          _QuickAction(
                            icon: Icons.person_add_outlined,
                            label: 'New Customer',
                            bg: colors.chipBlueBg,
                            fg: colors.chipBlueFg,
                            onTap: controller.onNewCustomer,
                          ),
                          _QuickAction(
                            icon: Icons.inventory_2_outlined,
                            label: 'Add Product',
                            bg: colors.surfaceContainerHigh,
                            fg: colors.onSurfaceVariant,
                            onTap: controller.onAddProduct,
                          ),
                          _QuickAction(
                            icon: Icons.payments_outlined,
                            label: 'Collect Payment',
                            bg: colors.chipAmberBg,
                            fg: colors.chipAmberFg,
                            onTap: controller.onCollectPayment,
                          ),
                        ],
                      ),
                    ),

                    Gaps.v4,

                    // ── Recent Invoices ───────────────────────
                    Padding(
                      padding: AppPadding.h20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Invoices',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: controller.onSeeAllInvoices,
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Obx(() => Column(
                          children: controller.recentInvoices
                              .map((inv) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 5,
                                    ),
                                    child: AppCard(
                                      onTap: () =>
                                          controller.onInvoiceTap(inv),
                                      child: Row(children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration:
                                              AppDecorations.iconContainer(
                                            color: colors.surfaceContainer,
                                            size: 12,
                                          ),
                                          child: Icon(
                                            Icons.description_outlined,
                                            color: colors.primary,
                                          ),
                                        ),
                                        Gaps.h12,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                inv['number']!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: colors.textPrimary,
                                                ),
                                              ),
                                              Text(
                                                inv['client']!,
                                                style: TextStyle(
                                                  color: colors.textSecondary,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              inv['amount']!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: colors.primary,
                                              ),
                                            ),
                                            Gaps.v4,
                                            StatusBadge(
                                              status: StatusBadge.fromString(
                                                inv['status']!,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ),
                                  ))
                              .toList(),
                        )),

                    const SizedBox(height: 100),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg, fg;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: AppDecorations.borderRadiusLG,
            boxShadow: AppDecorations.buttonShadow(bg),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: 26),
              Gaps.v8,
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
}
