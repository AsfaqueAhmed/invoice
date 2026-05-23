import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/configs/text_style/app_text_styles.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/gaps.dart';
import '../../../core/constants/margin.dart';
import '../../../core/constants/padding.dart';
import '../controllers/dashboard_controller.dart';
import '../models/dashboard_summary.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldLight,
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: AppColors.scaffoldLight,
        surfaceTintColor: AppColors.scaffoldLight,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFD0E1FB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.business_rounded,
                color: Color(0xFF54647A),
              ),
            ),
            Gaps.h12,
            Text(
              'InvoiceFlow',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            color: AppColors.primary,
            onPressed: () {},
          ),
          Gaps.h8,
        ],
      ),
      body: ListView(
        padding: AppPadding.page.copyWith(bottom: 120),
        children: [
          _SummaryScroller(summaries: controller.summaries),
          Gaps.v24,
          const Text('Quick Actions', style: AppTextStyles.headlineSmall),
          Gaps.v16,
          _QuickActionGrid(controller: controller),
          Gaps.v24,
          _RecentInvoicesHeader(onSeeAll: controller.openInvoices),
          Gaps.v16,
          ...controller.recentInvoices.map(
            (invoice) => Padding(
              padding: AppMargin.bottom16,
              child: _RecentInvoiceCard(invoice: invoice),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.onQuickAction('New Invoice'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 32),
      ),
      bottomNavigationBar: _DashboardBottomNav(controller: controller),
    );
  }
}

class _SummaryScroller extends StatelessWidget {
  const _SummaryScroller({required this.summaries});

  final List<DashboardSummary> summaries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: summaries.length,
        separatorBuilder: (_, __) => Gaps.h16,
        itemBuilder: (context, index) {
          return _SummaryCard(
            summary: summaries[index],
            width: index == 0 ? 280 : 240,
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.summary,
    required this.width,
  });

  final DashboardSummary summary;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: AppPadding.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey200.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary.label.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.grey600,
              letterSpacing: 1.1,
            ),
          ),
          Gaps.v8,
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              summary.value,
              style: AppTextStyles.displayMedium.copyWith(
                color: summary.valueColor,
                fontSize: summary.label == 'Today Sales' ? 36 : 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          if (summary.trend != null && summary.trendIcon != null)
            Row(
              children: [
                Icon(
                  summary.trendIcon,
                  color: const Color(0xFF943700),
                  size: 18,
                ),
                Gaps.h4,
                Text(
                  summary.trend!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF943700),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          else
            Text(
              summary.detail,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickActionGrid extends StatelessWidget {
  const _QuickActionGrid({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 128,
      ),
      itemBuilder: (context, index) {
        final action = controller.actions[index];

        return _QuickActionButton(
          action: action,
          onTap: () => controller.onQuickAction(action.label),
        );
      },
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.action,
    required this.onTap,
  });

  final DashboardAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: action.backgroundColor,
      borderRadius: BorderRadius.circular(24),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: AppPadding.all20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, size: 34, color: action.foregroundColor),
              Gaps.v8,
              Text(
                action.label,
                textAlign: TextAlign.center,
                style: AppTextStyles.labelMedium.copyWith(
                  color: action.foregroundColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentInvoicesHeader extends StatelessWidget {
  const _RecentInvoicesHeader({required this.onSeeAll});

  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text('Recent Invoices', style: AppTextStyles.headlineSmall),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: Text(
            'See All',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentInvoiceCard extends StatelessWidget {
  const _RecentInvoiceCard({required this.invoice});

  final RecentInvoice invoice;

  @override
  Widget build(BuildContext context) {
    final statusStyle = _recentStatusStyle(invoice.status);

    return Container(
      padding: AppPadding.all16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey200.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFEDEDF9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description_outlined,
              color: AppColors.primary,
            ),
          ),
          Gaps.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.number,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v4,
                Text(
                  invoice.customerName,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          Gaps.h12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                invoice.amount,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.grey900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v8,
              Container(
                padding: AppPadding.h12.add(AppPadding.v4),
                decoration: BoxDecoration(
                  color: statusStyle.backgroundColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  invoice.status.toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: statusStyle.textColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardBottomNav extends StatelessWidget {
  const _DashboardBottomNav({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 72,
      selectedIndex: 0,
      backgroundColor: AppColors.white,
      indicatorColor: AppColors.primary.withValues(alpha: 0.12),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) {
        final labels = [
          'Home',
          'Invoices',
          'Customers',
          'Products',
          'Settings'
        ];
        controller.onNavTapped(labels[index]);
      },
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(Icons.home_rounded),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.description_outlined),
          label: 'Invoices',
        ),
        NavigationDestination(
          icon: Icon(Icons.group_outlined),
          label: 'Customers',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Products',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}

class _RecentStatusStyle {
  const _RecentStatusStyle({
    required this.backgroundColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color textColor;
}

_RecentStatusStyle _recentStatusStyle(String status) {
  return switch (status) {
    'Paid' => const _RecentStatusStyle(
        backgroundColor: Color(0xFFD1FAE5),
        textColor: Color(0xFF047857),
      ),
    'Pending' => const _RecentStatusStyle(
        backgroundColor: Color(0xFFFEF3C7),
        textColor: Color(0xFFB45309),
      ),
    'Overdue' => const _RecentStatusStyle(
        backgroundColor: Color(0xFFFEE2E2),
        textColor: Color(0xFFB91C1C),
      ),
    _ => const _RecentStatusStyle(
        backgroundColor: AppColors.grey100,
        textColor: AppColors.grey700,
      ),
  };
}
