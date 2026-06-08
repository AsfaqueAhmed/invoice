import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/constants/padding.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bottom_nav.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/core/widgets/status_badge.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../business_setup/presentation/providers/business_setup_provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final businesses = ref.watch(businessListProvider).valueOrNull ?? [];
    final summary = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      backgroundColor: colors.scaffold,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.createInvoice),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardSummaryProvider.notifier).refresh(),
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
                  child: Builder(builder: (context) {
                    if (businesses.isEmpty) {
                      return Icon(
                        Icons.business_rounded,
                        color: cs.onSecondaryContainer,
                        size: 20,
                      );
                    }
                    final business = businesses.first;
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
                  }),
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
              child: summary.when(
                loading: () => SizedBox(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(color: colors.primary),
                  ),
                ),
                error: (error, stack) => SizedBox(
                  height: 400,
                  child: Center(
                    child: Text(
                      'Could not load dashboard data.',
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  ),
                ),
                data: (data) => Column(
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
                            value: data.todaySales,
                            sub: '+12% from yesterday',
                            subIcon: Icons.trending_up_rounded,
                            subColor: colors.tertiary,
                            valueColor: colors.primary,
                            valueSize: 26,
                          ),
                          Gaps.h12,
                          AppStatCard(
                            label: 'Due Amount',
                            value: data.dueAmount,
                            sub: '${data.totalInvoices} invoices',
                            valueColor: colors.error,
                          ),
                          Gaps.h12,
                          AppStatCard(
                            label: 'Collected',
                            value: data.collected,
                            sub: 'All time',
                            valueColor: colors.primary,
                          ),
                          Gaps.h12,
                          AppStatCard(
                            label: 'Total Invoices',
                            value: '${data.totalInvoices}',
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
                            onTap: () => Get.toNamed(Routes.createInvoice),
                          ),
                          _QuickAction(
                            icon: Icons.person_add_outlined,
                            label: 'New Customer',
                            bg: colors.chipBlueBg,
                            fg: colors.chipBlueFg,
                            onTap: () => Get.toNamed(Routes.ADD_CUSTOMER),
                          ),
                          _QuickAction(
                            icon: Icons.inventory_2_outlined,
                            label: 'Add Product',
                            bg: colors.surfaceContainerHigh,
                            fg: colors.onSurfaceVariant,
                            onTap: () => Get.toNamed(Routes.ADD_PRODUCT),
                          ),
                          _QuickAction(
                            icon: Icons.payments_outlined,
                            label: 'Collect Payment',
                            bg: colors.chipAmberBg,
                            fg: colors.chipAmberFg,
                            onTap: () => Get.toNamed(Routes.ADD_PAYMENT),
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
                            onPressed: () => Get.toNamed(Routes.invoices),
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

                    Column(
                      children: data.recentInvoices
                          .map((inv) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                                child: AppCard(
                                  onTap: () => Get.toNamed(
                                    Routes.invoiceDetails,
                                    arguments: inv,
                                  ),
                                  child: Row(children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: AppDecorations.iconContainer(
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
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
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
