import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_getx_app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/core/constants/gaps.dart';
import 'package:flutter_getx_app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/core/widgets/app_card.dart';
import '../controllers/due_payment_controller.dart';

class DuePaymentView extends GetView<DuePaymentController> {
  const DuePaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          backgroundColor: colors.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
            onPressed: Get.back,
          ),
          title: Text(
            'Due Payments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: colors.outline),
              onPressed: () {},
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              // ── Filter chips ──────────────────────────────
              SizedBox(
                height: 52,
                child: Obx(() => ListView(
                      scrollDirection: Axis.horizontal,
                      children: controller.filters.map((f) {
                        final active =
                            controller.selectedFilter.value == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => controller.onFilter(f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: AppDecorations.chipDecoration(
                                bg: active
                                    ? colors.primary
                                    : colors.surfaceContainerHigh,
                              ),
                              child: Text(
                                f,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: active
                                      ? colors.onPrimary
                                      : colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )),
              ),

              Gaps.v12,

              // ── Summary stat ──────────────────────────────
              AppCard(
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL DUE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Gaps.v4,
                        Text(
                          controller.totalDue,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.account_balance_wallet_rounded,
                        color: colors.primary),
                  ),
                ]),
              ),

              Gaps.v16,

              // ── Payment cards ─────────────────────────────
              Obx(() => Column(
                    children: controller.payments.map((p) {
                      final isOverdue = p['isOverdue'] as bool;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppCard(
                          color: isOverdue
                              ? colors.chipRedBg.withOpacity(0.5)
                              : null,
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
                                      decoration:
                                          AppDecorations.avatarDecoration(
                                              color: colors
                                                  .surfaceContainerHigh),
                                      child: Center(
                                        child: Text(
                                          p['name']
                                              .toString()
                                              .substring(0, 2),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: colors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gaps.h12,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: colors.textPrimary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Gaps.v4,
                                          Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 8,
                                                vertical: 3),
                                            decoration:
                                                AppDecorations.chipDecoration(
                                              bg: isOverdue
                                                  ? colors.chipRedBg
                                                  : colors.chipAmberBg,
                                            ),
                                            child: Text(
                                              p['badge'],
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: isOverdue
                                                    ? colors.error
                                                    : colors.warning,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                                Text(
                                  p['amount'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isOverdue
                                        ? colors.error
                                        : colors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Gaps.v12,
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
                                      backgroundColor: colors.primary,
                                      foregroundColor: colors.onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            AppDecorations.borderRadiusSM,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Gaps.h8,
                              _ActionIconBtn(
                                icon: Icons.call_outlined,
                                color: colors.primary,
                                bg: colors.surfaceContainerLow,
                                onTap: () => controller.onCall(p),
                              ),
                              Gaps.h8,
                              _ActionIconBtn(
                                icon: Icons.notifications_active_outlined,
                                color: colors.primary,
                                bg: colors.surfaceContainerLow,
                                onTap: () => controller.onRemind(p),
                              ),
                            ]),
                          ]),
                        ),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color, bg;
  final VoidCallback onTap;

  const _ActionIconBtn({
    required this.icon,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: AppDecorations.borderRadiusSM,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      );
}
