import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/configs/text_style/app_text_styles.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/gaps.dart';
import '../../../core/constants/margin.dart';
import '../../../core/constants/padding.dart';
import '../controllers/invoice_list_controller.dart';
import '../models/invoice_item.dart';

class InvoiceListView extends GetView<InvoiceListController> {
  const InvoiceListView({super.key});

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
            const Icon(Icons.business_rounded, color: AppColors.primary),
            Gaps.h12,
            Text(
              'Invoices',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            color: AppColors.grey600,
            onPressed: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            color: AppColors.grey600,
            onPressed: () {},
          ),
          Gaps.h8,
        ],
      ),
      body: Obx(
        () => ListView(
          padding: AppPadding.page.copyWith(bottom: 120),
          children: [
            _SearchField(controller: controller),
            Gaps.v16,
            _FilterChips(controller: controller),
            Gaps.v8,
            _SummaryCards(controller: controller),
            Gaps.v24,
            if (controller.filteredInvoices.isEmpty)
              const _EmptyInvoices()
            else
              ...controller.filteredInvoices.map(
                (invoice) => Padding(
                  padding: AppMargin.bottom16,
                  child: _InvoiceCard(invoice: invoice),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addInvoice,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 32),
      ),
      bottomNavigationBar: _InvoiceBottomNav(controller: controller),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final InvoiceListController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.searchController,
      onChanged: controller.updateSearch,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search by number or name...',
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey400),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.grey400),
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune_rounded, color: AppColors.grey400),
          onPressed: controller.openFilterSheet,
        ),
        filled: true,
        fillColor: AppColors.grey100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: AppPadding.h16.add(AppPadding.v16),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.controller});

  final InvoiceListController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: controller.filters
            .map(
              (filter) => Obx(
                () => Padding(
                  padding: AppPadding.right8,
                  child: ChoiceChip(
                    selected: controller.selectedFilter.value == filter,
                    label: Text(filter),
                    onSelected: (_) => controller.selectFilter(filter),
                    showCheckmark: false,
                    selectedColor: _filterColor(filter),
                    backgroundColor: _filterColor(filter),
                    labelStyle: AppTextStyles.labelMedium.copyWith(
                      color: _filterTextColor(filter),
                      fontWeight: FontWeight.w700,
                    ),
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    padding: AppPadding.h12.add(AppPadding.v8),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Color _filterColor(String filter) {
    return switch (filter) {
      'All' => AppColors.primary,
      'Paid' => const Color(0xFFD1FAE5),
      'Partial' => const Color(0xFFFEF3C7),
      'Due' => const Color(0xFFFFE4E6),
      'Overdue' => const Color(0xFFFECACA),
      _ => AppColors.grey100,
    };
  }

  Color _filterTextColor(String filter) {
    return switch (filter) {
      'All' => AppColors.white,
      'Paid' => const Color(0xFF065F46),
      'Partial' => const Color(0xFF92400E),
      'Due' => const Color(0xFF9F1239),
      'Overdue' => const Color(0xFF450A0A),
      _ => AppColors.grey700,
    };
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.controller});

  final InvoiceListController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Total Receivable',
            amount: controller.totalReceivable,
            backgroundColor: AppColors.white,
            labelColor: AppColors.grey600,
            amountColor: AppColors.grey900,
          ),
        ),
        Gaps.h16,
        Expanded(
          child: _SummaryCard(
            label: 'Collected (MTD)',
            amount: controller.collectedMonthToDate,
            backgroundColor: AppColors.primary,
            labelColor: AppColors.white.withValues(alpha: 0.82),
            amountColor: AppColors.white,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.backgroundColor,
    required this.labelColor,
    required this.amountColor,
  });

  final String label;
  final double amount;
  final Color backgroundColor;
  final Color labelColor;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 104),
      padding: AppPadding.all16,
      decoration: BoxDecoration(
        color: backgroundColor,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: labelColor),
          ),
          Gaps.v4,
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _formatCurrency(amount),
              style: AppTextStyles.headlineSmall.copyWith(
                color: amountColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceCard extends StatefulWidget {
  const _InvoiceCard({required this.invoice});

  final InvoiceItem invoice;

  @override
  State<_InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<_InvoiceCard> {
  double _dragOffset = 0;

  @override
  Widget build(BuildContext context) {
    const actionWidth = 80.0;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset = (_dragOffset + details.delta.dx).clamp(-actionWidth, 0);
        });
      },
      onHorizontalDragEnd: (_) {
        setState(() {
          _dragOffset = _dragOffset.abs() > actionWidth / 2 ? -actionWidth : 0;
        });
      },
      onTap: () {
        setState(() {
          _dragOffset = _dragOffset == 0 ? -actionWidth : 0;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: actionWidth,
                  color: AppColors.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.invoice.trailingIcon, color: AppColors.white),
                      Gaps.v4,
                      Text(
                        widget.invoice.trailingAction,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(_dragOffset, 0, 0),
              padding: AppPadding.all16,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: AppColors.grey200.withValues(alpha: 0.45)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.05),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.invoice.number} • ${widget.invoice.date}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                        Gaps.v4,
                        Text(
                          widget.invoice.customerName,
                          style: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.grey900,
                            fontSize: 20,
                          ),
                        ),
                        Gaps.v12,
                        _StatusBadge(status: widget.invoice.status),
                      ],
                    ),
                  ),
                  Gaps.h12,
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 128),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            _formatCurrency(widget.invoice.amount),
                            style: AppTextStyles.titleLarge.copyWith(
                              color: widget.invoice.status == InvoiceStatus.paid
                                  ? AppColors.primary
                                  : AppColors.grey900,
                            ),
                          ),
                        ),
                        Gaps.v4,
                        Text(
                          widget.invoice.projectName,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle(status);

    return Container(
      padding: AppPadding.h12.add(AppPadding.v4),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: style.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          Gaps.h8,
          Text(
            _statusLabel(status),
            style: AppTextStyles.labelSmall.copyWith(
              color: style.textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceBottomNav extends StatelessWidget {
  const _InvoiceBottomNav({required this.controller});

  final InvoiceListController controller;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 72,
      selectedIndex: 1,
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
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.description_rounded),
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

class _EmptyInvoices extends StatelessWidget {
  const _EmptyInvoices();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.description_outlined,
            color: AppColors.grey400,
            size: 42,
          ),
          Gaps.v12,
          Text(
            'No invoices found',
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.grey900),
          ),
          Gaps.v4,
          Text(
            'Try a different search or filter.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  const _StatusStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.dotColor,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color dotColor;
}

_StatusStyle _statusStyle(InvoiceStatus status) {
  return switch (status) {
    InvoiceStatus.paid => const _StatusStyle(
        backgroundColor: Color(0xFFD1FAE5),
        textColor: Color(0xFF065F46),
        dotColor: Color(0xFF059669),
      ),
    InvoiceStatus.partial => const _StatusStyle(
        backgroundColor: Color(0xFFFEF3C7),
        textColor: Color(0xFF92400E),
        dotColor: Color(0xFFD97706),
      ),
    InvoiceStatus.due => const _StatusStyle(
        backgroundColor: Color(0xFFFFE4E6),
        textColor: Color(0xFF9F1239),
        dotColor: Color(0xFFE11D48),
      ),
    InvoiceStatus.overdue => const _StatusStyle(
        backgroundColor: Color(0xFFFECACA),
        textColor: Color(0xFF450A0A),
        dotColor: Color(0xFFB91C1C),
      ),
  };
}

String _statusLabel(InvoiceStatus status) {
  return switch (status) {
    InvoiceStatus.paid => 'Paid',
    InvoiceStatus.partial => 'Partial',
    InvoiceStatus.due => 'Due',
    InvoiceStatus.overdue => 'Overdue',
  };
}

String _formatCurrency(double amount) {
  final whole = amount.round().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < whole.length; i++) {
    final fromRight = whole.length - i;
    buffer.write(whole[i]);
    if (fromRight > 1 && fromRight % 3 == 1) {
      buffer.write(',');
    }
  }

  return '\$${buffer.toString()}.00';
}
