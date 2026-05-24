import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bottom_nav.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/core/widgets/status_badge.dart';
import 'package:flutter_getx_app/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: controller.onNewInvoice,
          child: const Icon(Icons.add_rounded, size: 28)),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          backgroundColor: isDark ? AppColor.darkSurface : AppColors.surface,
          elevation: 0,
          title: Row(children: [
            Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: cs.secondaryContainer, shape: BoxShape.circle),
                child: Icon(Icons.business_rounded,
                    color: cs.onSecondaryContainer, size: 20)),
            const SizedBox(width: 10),
            Text('InvoiceFlow',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: cs.primary)),
          ]),
          actions: [
            IconButton(
                icon: Icon(Icons.notifications_outlined, color: cs.primary),
                onPressed: () {})
          ],
        ),
        SliverToBoxAdapter(child: Obx(() {
          if (controller.isLoading.value)
            return const SizedBox(
                height: 400, child: Center(child: CircularProgressIndicator()));
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                SizedBox(
                    height: 155,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _SummaryCard(
                            label: 'Today Sales',
                            value: controller.todaySales.value,
                            sub: '+12% from yesterday',
                            subIcon: Icons.trending_up_rounded,
                            subColor: AppColor.tertiary,
                            valueColor: cs.primary,
                            valueSize: 26,
                            width: 230),
                        const SizedBox(width: 12),
                        _SummaryCard(
                            label: 'Due Amount',
                            value: controller.dueAmount.value,
                            sub: '8 invoices pending',
                            valueColor: cs.error,
                            width: 200),
                        const SizedBox(width: 12),
                        _SummaryCard(
                            label: 'Collected',
                            value: controller.collected.value,
                            sub: 'This month',
                            valueColor: cs.primary,
                            width: 200),
                        const SizedBox(width: 12),
                        _SummaryCard(
                            label: 'Total Invoices',
                            value: '${controller.totalInvoices.value}',
                            sub: 'All time',
                            width: 200),
                        const SizedBox(width: 20),
                      ],
                    )),
                const SizedBox(height: 24),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Quick Actions',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600))),
                const SizedBox(height: 12),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _QuickAction(
                            icon: Icons.add_circle_outline_rounded,
                            label: 'New Invoice',
                            bg: cs.primaryContainer,
                            fg: cs.onPrimaryContainer,
                            onTap: controller.onNewInvoice),
                        _QuickAction(
                            icon: Icons.person_add_outlined,
                            label: 'New Customer',
                            bg: AppColor.secondaryFixed,
                            fg: AppColor.onSecondaryFixed,
                            onTap: controller.onNewCustomer),
                        _QuickAction(
                            icon: Icons.inventory_2_outlined,
                            label: 'Add Product',
                            bg: cs.surfaceContainerHigh,
                            fg: cs.onSurfaceVariant,
                            onTap: controller.onAddProduct),
                        _QuickAction(
                            icon: Icons.payments_outlined,
                            label: 'Collect Payment',
                            bg: AppColor.tertiaryFixed,
                            fg: AppColor.onTertiaryFixed,
                            onTap: controller.onCollectPayment),
                      ],
                    )),
                const SizedBox(height: 24),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Recent Invoices',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          TextButton(
                              onPressed: controller.onSeeAllInvoices,
                              child: Text('See All',
                                  style: TextStyle(
                                      color: cs.primary,
                                      fontWeight: FontWeight.w600))),
                        ])),
                ...controller.recentInvoices.map((inv) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: AppCard(
                          onTap: () => controller.onInvoiceTap(inv),
                          child: Row(children: [
                            Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                    color: cs.surfaceContainer,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Icon(Icons.description_outlined,
                                    color: cs.primary)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(inv['number']!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14)),
                                  Text(inv['client']!,
                                      style: TextStyle(
                                          color: cs.onSurfaceVariant,
                                          fontSize: 13)),
                                ])),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(inv['amount']!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14)),
                                  const SizedBox(height: 4),
                                  StatusBadge(
                                      status: StatusBadge.fromString(
                                          inv['status']!)),
                                ]),
                          ])),
                    )),
                const SizedBox(height: 100),
              ]);
        })),
      ]),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, value, sub;
  final Color? valueColor, subColor;
  final IconData? subIcon;
  final double width, valueSize;

  const _SummaryCard(
      {required this.label,
      required this.value,
      required this.sub,
      this.valueColor,
      this.subColor,
      this.subIcon,
      this.width = 200,
      this.valueSize = 20});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppCard(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: width,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label.toUpperCase(),
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: cs.secondary,
                        letterSpacing: 0.8)),
                Text(value,
                    style: TextStyle(
                        fontSize: valueSize,
                        fontWeight: FontWeight.w700,
                        color: valueColor ?? cs.onSurface,
                        letterSpacing: -0.5)),
                Row(children: [
                  if (subIcon != null) ...[
                    Icon(subIcon,
                        size: 13, color: subColor ?? cs.onSurfaceVariant),
                    const SizedBox(width: 4)
                  ],
                  Text(sub,
                      style: TextStyle(
                          fontSize: 11,
                          color: subColor ?? cs.onSurfaceVariant)),
                ]),
              ]),
        ));
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg, fg;
  final VoidCallback onTap;

  const _QuickAction(
      {required this.icon,
      required this.label,
      required this.bg,
      required this.fg,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: 26),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
}
