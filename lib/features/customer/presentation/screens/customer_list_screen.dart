import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/constants/padding.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bottom_nav.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/core/widgets/app_text_field.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../domain/entities/customer_entity.dart';
import '../providers/customer_list_provider.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onAddCustomer() async {
    await Get.toNamed(Routes.ADD_CUSTOMER);
    ref.invalidate(customerListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final customers = ref.watch(customerListProvider);

    return Scaffold(
      backgroundColor: colors.scaffold,
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddCustomer,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: RefreshIndicator(
        onRefresh: () => ref.read(customerListProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              backgroundColor: colors.surface,
              elevation: 0,
              title: Row(children: [
                Icon(Icons.account_balance_wallet_rounded, color: colors.primary),
                Gaps.h8,
                Text(
                  'Customers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
              ]),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: AppPadding.all20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Search ─────────────────────────────────
                    AppTextField(
                      hintText: 'Search by name or phone...',
                      controller: _searchController,
                      onChanged: (v) =>
                          ref.read(customerSearchQueryProvider.notifier).state = v,
                      prefixIcon:
                          Icon(Icons.search_rounded, color: colors.outline),
                    ),

                    Gaps.v16,

                    // ── Stats ──────────────────────────────────
                    Row(children: [
                      Expanded(
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL CUSTOMERS',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textSecondary,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Gaps.v4,
                              Text(
                                '${ref.watch(totalCustomersProvider)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gaps.h12,
                      Expanded(
                        child: AppCard(
                          color: colors.errorContainer.withOpacity(0.3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL OVERDUE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: colors.error,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Gaps.v4,
                              Text(
                                ref.watch(totalCustomerOverdueProvider),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: colors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),

                    Gaps.v20,

                    Text(
                      'Active Customers',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),

                    Gaps.v8,

                    // ── Customer Cards ─────────────────────────
                    customers.when(
                      loading: () => Center(
                        child: Padding(
                          padding: AppPadding.v32,
                          child: CircularProgressIndicator(color: colors.primary),
                        ),
                      ),
                      error: (error, _) => _EmptyState(
                        icon: Icons.error_outline_rounded,
                        message: 'Could not load customers.',
                        colors: colors,
                      ),
                      data: (_) {
                        final list = ref.watch(filteredCustomersProvider);
                        if (list.isEmpty) {
                          return _EmptyState(
                            icon: Icons.group_outlined,
                            message: 'No customers found.',
                            colors: colors,
                          );
                        }
                        return Column(
                          children: list
                              .map((c) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _CustomerCard(
                                      customer: c,
                                      colors: colors,
                                      onTap: () => Get.toNamed(
                                          Routes.CUSTOMER_DETAILS,
                                          arguments: c.id),
                                    ),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
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

class _CustomerCard extends StatelessWidget {
  final CustomerEntity customer;
  final AppColorBase colors;
  final VoidCallback onTap;

  const _CustomerCard({
    required this.customer,
    required this.colors,
    required this.onTap,
  });

  String get _initials {
    final parts = customer.name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?';
  }

  bool get _hasOverdue => customer.totalDue > 0;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          Row(children: [
            Container(
              width: 52,
              height: 52,
              decoration:
                  AppDecorations.avatarDecoration(color: colors.chipBlueBg),
              child: Center(
                child: Text(
                  _initials,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: colors.primary,
                  ),
                ),
              ),
            ),
            Gaps.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    customer.phone,
                    style: TextStyle(color: colors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.more_vert_rounded, color: colors.outline),
          ]),
          Gaps.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ADDRESS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    customer.address.isNotEmpty ? customer.address : 'N/A',
                    style: TextStyle(fontSize: 13, color: colors.textSecondary),
                  ),
                  Gaps.v6,
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: AppDecorations.chipDecoration(
                      bg: _hasOverdue ? colors.chipRedBg : colors.chipGreenBg,
                    ),
                    child: Text(
                      _hasOverdue ? 'Has Overdue' : 'Cleared',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _hasOverdue ? colors.chipRedFg : colors.chipGreenFg,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'DUE AMOUNT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    _hasOverdue
                        ? '\$${customer.totalDue.toStringAsFixed(2)}'
                        : '\$0.00',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _hasOverdue ? colors.error : colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final AppColorBase colors;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppPadding.v32,
        child: Column(
          children: [
            Icon(icon, size: 48, color: colors.outline),
            Gaps.v12,
            Text(message, style: TextStyle(color: colors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
