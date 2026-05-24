import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:get/get.dart';

import '../controllers/due_payment_controller.dart';

class DuePaymentView extends GetView<DuePaymentController> {
  const DuePaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: const Icon(Icons.add_rounded, size: 28)),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          backgroundColor: isDark ? AppColor.darkSurface : AppColor.surface,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
              onPressed: Get.back),
          title: Text('Due Payments',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface)),
          actions: [
            IconButton(
                icon: Icon(Icons.notifications_outlined,
                    color: cs.onSurfaceVariant),
                onPressed: () {}),
          ],
        ),
        SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  // Filter chips
                  SizedBox(
                      height: 52,
                      child: Obx(() => ListView(
                          scrollDirection: Axis.horizontal,
                          children: controller.filters.map((f) {
                            final active = controller.selectedFilter.value == f;
                            return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                    onTap: () => controller.onFilter(f),
                                    child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                            color: active
                                                ? cs.primary
                                                : cs.surfaceContainerHigh,
                                            borderRadius:
                                                BorderRadius.circular(99)),
                                        child: Text(f,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: active
                                                    ? cs.onPrimary
                                                    : cs.onSurfaceVariant)))));
                          }).toList()))),
                  const SizedBox(height: 12),
                  // Summary stat
                  AppCard(
                      child: Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('TOTAL DUE',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurfaceVariant,
                                  letterSpacing: 0.8)),
                          const SizedBox(height: 4),
                          Text(controller.totalDue,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface)),
                        ])),
                    Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.1),
                            shape: BoxShape.circle),
                        child: Icon(Icons.account_balance_wallet_rounded,
                            color: cs.primary)),
                  ])),
                  const SizedBox(height: 16),
                  // Payment cards
                  Obx(() => Column(
                          children: controller.payments.map((p) {
                        final isOverdue = p['isOverdue'] as bool;
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isOverdue
                                      ? (isDark
                                          ? AppColor.darkSurfaceContainer
                                          : const Color(0xFFFFF9F9))
                                      : (isDark
                                          ? AppColor.darkSurfaceContainer
                                          : Colors.white),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: isOverdue
                                          ? cs.error.withOpacity(0.2)
                                          : cs.outlineVariant.withOpacity(0.2)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 16,
                                        offset: const Offset(0, 4))
                                  ]),
                              child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Row(children: [
                                            Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: cs
                                                        .surfaceContainerHigh),
                                                child: Center(
                                                    child: Text(
                                                        p['name']
                                                            .toString()
                                                            .substring(0, 2),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                cs.primary)))),
                                            const SizedBox(width: 12),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  Text(p['name'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14),
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 3),
                                                      decoration: BoxDecoration(
                                                          color: isOverdue
                                                              ? cs.errorContainer
                                                                  .withOpacity(
                                                                      0.3)
                                                              : AppColor
                                                                  .tertiaryFixed
                                                                  .withOpacity(
                                                                      0.4),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  6)),
                                                      child: Text(p['badge'],
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight: FontWeight
                                                                  .w700,
                                                              color: isOverdue
                                                                  ? cs.error
                                                                  : AppColor.tertiary,
                                                              letterSpacing: 0.3))),
                                                ])),
                                          ])),
                                          Text(p['amount'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: isOverdue
                                                      ? cs.error
                                                      : cs.onSurface)),
                                        ]),
                                    const SizedBox(height: 12),
                                    Row(children: [
                                      Expanded(
                                          child: SizedBox(
                                              height: 48,
                                              child: ElevatedButton.icon(
                                                  onPressed: () =>
                                                      controller.onCollect(p),
                                                  icon: const Icon(
                                                      Icons.payments_outlined,
                                                      size: 16),
                                                  label: const Text('Collect'),
                                                  style: ElevatedButton.styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)))))),
                                      const SizedBox(width: 8),
                                      _ActionIconBtn(
                                          icon: Icons.call_outlined,
                                          color: cs.primary,
                                          onTap: () => controller.onCall(p),
                                          bg: cs.surfaceContainerLow),
                                      const SizedBox(width: 8),
                                      _ActionIconBtn(
                                          icon: Icons
                                              .notifications_active_outlined,
                                          color: cs.primary,
                                          onTap: () => controller.onRemind(p),
                                          bg: cs.surfaceContainerLow),
                                    ]),
                                  ])),
                            ));
                      }).toList())),
                  const SizedBox(height: 100),
                ]))),
      ]),
    );
  }
}

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color, bg;
  final VoidCallback onTap;

  const _ActionIconBtn(
      {required this.icon,
      required this.color,
      required this.bg,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
          width: 48,
          height: 48,
          decoration:
              BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 22)));
}
