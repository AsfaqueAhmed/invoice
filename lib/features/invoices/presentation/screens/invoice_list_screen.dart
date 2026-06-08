import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/constants/padding.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bottom_nav.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/core/widgets/app_text_field.dart';
import 'package:flutter_getx_app/app/core/widgets/status_badge.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/invoice_list_provider.dart';

class InvoiceListScreen extends ConsumerStatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  ConsumerState<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends ConsumerState<InvoiceListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final invoices = ref.watch(invoiceListProvider);
    final selectedFilter = ref.watch(invoiceStatusFilterProvider);

    return Scaffold(
      backgroundColor: colors.scaffold,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.createInvoice),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: RefreshIndicator(
        onRefresh: () => ref.read(invoiceListProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
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
              child: Column(
                children: [
                  // ── Search ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                    child: AppTextField(
                      hintText: 'Search by number or name...',
                      controller: _searchController,
                      onChanged: (value) =>
                          ref.read(invoiceSearchQueryProvider.notifier).state =
                              value,
                      prefixIcon:
                          Icon(Icons.search_rounded, color: colors.outline),
                      suffixIcon:
                          Icon(Icons.tune_rounded, color: colors.outline),
                    ),
                  ),

                  // ── Filter chips ────────────────────────────
                  SizedBox(
                    height: 52,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: AppPadding.h20.copyWith(top: 8, bottom: 8),
                      children: invoiceStatusFilters.map((filter) {
                        final active = selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => ref
                                .read(invoiceStatusFilterProvider.notifier)
                                .state = filter,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 6),
                              decoration: AppDecorations.chipDecoration(
                                bg: active
                                    ? colors.primary
                                    : colors.surfaceContainerHigh,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                filter,
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
                    ),
                  ),

                  // ── Stats ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                    child: Row(children: [
                      Expanded(
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                ref.watch(totalReceivableProvider),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                ref.watch(collectedToDateProvider),
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
                    ]),
                  ),

                  // ── Invoice list ─────────────────────────────
                  invoices.when(
                    loading: () => Center(
                      child: Padding(
                        padding: AppPadding.v32,
                        child:
                            CircularProgressIndicator(color: colors.primary),
                      ),
                    ),
                    error: (error, _) => Center(
                      child: Padding(
                        padding: AppPadding.v32,
                        child: Text(
                          'Could not load invoices.',
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      ),
                    ),
                    data: (_) {
                      final filtered = ref.watch(filteredInvoicesProvider);
                      if (filtered.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: AppPadding.v32,
                            child: Column(children: [
                              Icon(Icons.description_outlined,
                                  size: 48, color: colors.outline),
                              Gaps.v12,
                              Text(
                                'No invoices found.',
                                style: TextStyle(color: colors.textSecondary),
                              ),
                            ]),
                          ),
                        );
                      }
                      return Column(
                        children: filtered
                            .map((invoice) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: AppCard(
                                    onTap: () => Get.toNamed(
                                      Routes.invoiceDetails,
                                      arguments: invoice.id,
                                    ),
                                    child: Row(children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '#${invoice.invoiceNo}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: colors.textSecondary,
                                              ),
                                            ),
                                            Gaps.v4,
                                            Text(
                                              invoice.customerName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: colors.textPrimary,
                                              ),
                                            ),
                                            Gaps.v6,
                                            Row(children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                margin: const EdgeInsets.only(
                                                    right: 6),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: _statusColor(
                                                      invoice.status, colors),
                                                ),
                                              ),
                                              StatusBadge(
                                                status: StatusBadge.fromString(
                                                    invoice.status),
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
                                            invoice.formattedTotal,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                              color: colors.primary,
                                            ),
                                          ),
                                          Gaps.v4,
                                          Text(
                                            invoice.dueTag,
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
                    },
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status, AppColorBase colors) {
    switch (status) {
      case 'paid':
        return colors.successText;
      case 'partial':
        return colors.warningText;
      case 'overdue':
        return colors.error;
      default:
        return colors.warningText;
    }
  }
}
