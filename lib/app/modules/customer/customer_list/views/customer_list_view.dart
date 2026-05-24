import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bottom_nav.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/modules/customer/customer_list/controllers/customer_list_controller.dart';
import 'package:get/get.dart';

class CustomerListView extends GetView<CustomerListController> {
  const CustomerListView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: controller.onAddCustomer,
          child: const Icon(Icons.add_rounded, size: 28)),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: isDark ? AppColor.darkSurface : AppColor.surface,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6).copyWith(top:12),
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet_rounded, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Customers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.v4,
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16).copyWith(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search
                    TextField(
                      controller: controller.searchController,
                      onChanged: controller.onSearch,
                      decoration: const InputDecoration(
                        hintText: 'Search by name or phone...',
                        prefixIcon: Icon(Icons.search_rounded),
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stats
                    Row(
                      children: [
                        Expanded(
                          child: AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Customers',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: cs.secondary,
                                        letterSpacing: 0.8)),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${controller.totalCustomers}',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: cs.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '+12% this month',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: cs.primary.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppCard(
                            color: cs.errorContainer.withValues(alpha: 0.3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Overdue',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: cs.error,
                                        letterSpacing: 0.8)),
                                const SizedBox(height: 4),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Flexible(
                                        child: FittedBox(
                                          child: Text(
                                            controller.totalOverdue,
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                              color: cs.error,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text('24 Pending',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: cs.error
                                                  .withValues(alpha: 0.6))),
                                    ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Active Customers',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600)),
                          TextButton.icon(
                              onPressed: () {},
                              icon:
                                  const Icon(Icons.filter_list_rounded, size: 16),
                              label: const Text('Filter')),
                        ]),
                    const SizedBox(height: 8),
                    // Customer cards
                    Obx(() => Column(
                        children: controller.filtered
                            .map((c) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: AppCard(
                                      onTap: () => controller.onCustomerTap(c),
                                      child: Column(children: [
                                        Row(children: [
                                          Container(
                                              width: 52,
                                              height: 52,
                                              decoration: BoxDecoration(
                                                  color: AppColor.primaryFixed,
                                                  borderRadius:
                                                      BorderRadius.circular(14)),
                                              child: Center(
                                                  child: Text(c['initials'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16,
                                                          color: cs.primary)))),
                                          const SizedBox(width: 12),
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                Text(c['name'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15)),
                                                Text(c['phone'],
                                                    style: TextStyle(
                                                        color: cs.secondary,
                                                        fontSize: 13)),
                                              ])),
                                          IconButton(
                                              icon: Icon(Icons.more_vert_rounded,
                                                  color: cs.outline),
                                              onPressed: () {}),
                                        ]),
                                        const SizedBox(height: 12),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('LAST INVOICE',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: cs.secondary,
                                                            letterSpacing: 0.6)),
                                                    Text(c['lastInvoice'],
                                                        style: const TextStyle(
                                                            fontSize: 13)),
                                                    const SizedBox(height: 6),
                                                    Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10,
                                                            vertical: 4),
                                                        decoration: BoxDecoration(
                                                            color: _statusBg(
                                                                c['status'],
                                                                c['hasOverdue']),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        99)),
                                                        child: Text(c['status'],
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: _statusFg(
                                                                    c['status'],
                                                                    c['hasOverdue'],
                                                                    cs)))),
                                                  ]),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text('DUE AMOUNT',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: cs.secondary,
                                                            letterSpacing: 0.6)),
                                                    Text(c['due'],
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: c['due'] ==
                                                                    r'$0.00'
                                                                ? cs.onSurface
                                                                : cs.error)),
                                                  ]),
                                            ]),
                                      ])),
                                ))
                            .toList())),
                    // Add new placeholder
                    GestureDetector(
                      onTap: controller.onAddCustomer,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: cs.outlineVariant.withValues(alpha: 0.5),
                                width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                  color: cs.surfaceContainer,
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.add_rounded,
                                color: cs.outline,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add New Customer',
                              style: TextStyle(
                                color: cs.outline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
      ),
    );
  }

  Color _statusBg(String s, bool overdue) {
    if (overdue) return AppColor.errorContainer.withValues(alpha: 0.2);
    if (s.contains('VIP')) return AppColor.successBg;
    if (s.contains('Active')) return AppColor.successBg;
    return AppColor.surfaceContainerHigh;
  }

  Color _statusFg(String s, bool overdue, ColorScheme cs) {
    if (overdue) return cs.error;
    if (s.contains('VIP') || s.contains('Active')) return AppColor.successText;
    return cs.onSurfaceVariant;
  }
}
