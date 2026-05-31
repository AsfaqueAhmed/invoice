import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/constants/gaps.dart';
import '../../../../core/constants/padding.dart';
import '../../../../core/constants/app_decorations.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/status_badge.dart';
import '../controllers/invoice_list_controller.dart';

class InvoiceListView extends GetView<InvoiceListController> {
  const InvoiceListView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onCreateInvoice,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: colors.surface,
              elevation: 0,
              title: Text(
                'Invoices',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications_outlined,
                      color: colors.onSurfaceVariant),
                  onPressed: () {},
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(children: [
                // ── Search ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: AppTextField(
                    hintText: 'Search by number or name...',
                    controller: controller.searchController,
                    onChanged: controller.onSearch,
                    prefixIcon: Icon(Icons.search_rounded,
                        color: colors.outline),
                    suffixIcon: Icon(Icons.tune_rounded,
                        color: colors.outline),
                  ),
                ),

                // ── Filter chips ────────────────────────────
                SizedBox(
                  height: 56,
                  child: Obx(() => ListView(
                        scrollDirection: Axis.horizontal,
                        padding: AppPadding.h20
                            .copyWith(top: 8, bottom: 8),
                        children: controller.filters.map((f) {
                          final active =
                              controller.selectedFilter.value == f;
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => controller.onFilter(f),
                              child: AnimatedContainer(
                                duration: const Duration(
                                    milliseconds: 200),
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6),
                                decoration:
                                    AppDecorations.chipDecoration(
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

                // ── Stats ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  child: Obx(() => Row(children: [
                        Expanded(
                          child: AppCard(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Receivable',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Gaps.v4,
                                Text(
                                  controller.totalReceivable,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: colors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gaps.h12,
                        Expanded(
                          child: AppCard(
                            color: colors.primaryContainer,
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Collected (MTD)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.onPrimaryContainer
                                        .withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Gaps.v4,
                                Text(
                                  controller.collectedMTD,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: colors.onPrimaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])),
                ),

                // ── Invoice list ─────────────────────────────
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: Padding(
                        padding: AppPadding.v32,
                        child: CircularProgressIndicator(
                            color: colors.primary),
                      ),
                    );
                  }
                  final list = controller.filtered;
                  if (list.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: AppPadding.v32,
                        child: Column(children: [
                          Icon(Icons.description_outlined,
                              size: 48, color: colors.outline),
                          Gaps.v12,
                          Text(
                            'No invoices found.',
                            style: TextStyle(
                                color: colors.textSecondary),
                          ),
                        ]),
                      ),
                    );
                  }
                  return Column(
                    children: list
                        .map((inv) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: AppCard(
                                onTap: () =>
                                    controller.onInvoiceTap(inv),
                                child: Row(children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '#${inv['number']}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: colors
                                                .textSecondary,
                                          ),
                                        ),
                                        Gaps.v4,
                                        Text(
                                          inv['client'],
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.w600,
                                            fontSize: 15,
                                            color: colors.textPrimary,
                                          ),
                                        ),
                                        Gaps.v6,
                                        Row(children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            margin:
                                                const EdgeInsets.only(
                                                    right: 6),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _statusColor(
                                                  inv['status'],
                                                  colors),
                                            ),
                                          ),
                                          StatusBadge(
                                            status:
                                                StatusBadge.fromString(
                                                    inv['status']),
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        inv['amount'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: colors.primary,
                                        ),
                                      ),
                                      Gaps.v4,
                                      Text(
                                        inv['tag'],
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ))
                        .toList(),
                  );
                }),

                const SizedBox(height: 100),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String s, AppColorBase colors) {
    switch (s) {
      case 'paid': return colors.successText;
      case 'partial': return colors.warningText;
      case 'overdue': return colors.error;
      default: return colors.warningText;
    }
  }
}
