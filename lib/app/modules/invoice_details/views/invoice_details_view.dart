import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/configs/text_style/app_text_styles.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/gaps.dart';
import '../../../core/constants/padding.dart';
import '../controllers/invoice_details_controller.dart';
import '../models/invoice_detail_item.dart';

class InvoiceDetailsView extends GetView<InvoiceDetailsController> {
  const InvoiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldLight,
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: AppColors.scaffoldLight,
        surfaceTintColor: AppColors.scaffoldLight,
        leadingWidth: 64,
        leading: Padding(
          padding: AppPadding.h8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.primary,
            onPressed: Get.back<void>,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          'Invoice #1024',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: AppPadding.right8,
            decoration: const BoxDecoration(
              color: Color(0xFFDBE1FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.business_rounded,
              color: Color(0xFF00174B),
            ),
          ),
          Gaps.h8,
        ],
      ),
      body: ListView(
        padding: AppPadding.page.copyWith(bottom: 112),
        children: [
          const _PaidStatusBanner(),
          Gaps.v24,
          _InvoiceCanvas(controller: controller),
        ],
      ),
      bottomNavigationBar: _InvoiceDetailsActionBar(controller: controller),
    );
  }
}

class _PaidStatusBanner extends StatelessWidget {
  const _PaidStatusBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.v16.add(AppPadding.h16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF2E7D32),
          ),
          Gaps.h8,
          Text(
            'INVOICE FULLY PAID',
            style: AppTextStyles.labelSmall.copyWith(
              color: const Color(0xFF2E7D32),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceCanvas extends StatelessWidget {
  const _InvoiceCanvas({required this.controller});

  final InvoiceDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 620),
      padding: AppPadding.all20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
          const _InvoiceHeader(),
          Gaps.v24,
          const Divider(color: AppColors.grey300),
          Gaps.v24,
          const _CustomerInfo(),
          Gaps.v24,
          _ItemizedTable(items: controller.items),
          Gaps.v24,
          Align(
            alignment: Alignment.centerRight,
            child: _PaymentSummary(controller: controller),
          ),
          Gaps.v32,
          const _FooterNote(),
        ],
      ),
    );
  }
}

class _InvoiceHeader extends StatelessWidget {
  const _InvoiceHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'InvoiceFlow',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Gaps.v4,
              Text(
                '123 Financial District\nNew York, NY 10001',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'DATE ISSUED',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.grey600,
                letterSpacing: 0.8,
              ),
            ),
            Gaps.v4,
            Text(
              'Oct 24, 2023',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.grey900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CustomerInfo extends StatelessWidget {
  const _CustomerInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: _InfoBlock(
            label: 'BILLED TO',
            title: 'Acme Corp International',
            body: 'Sarah Jenkins\n456 Business Way\nSan Francisco, CA 94105',
          ),
        ),
        Gaps.h16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'PAYMENT TERMS',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.grey600,
                  letterSpacing: 0.8,
                ),
              ),
              Gaps.v8,
              Text(
                'Due on Receipt',
                textAlign: TextAlign.right,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.grey900,
                ),
              ),
              Gaps.v8,
              Container(
                padding: AppPadding.all8,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ID: INV-2023-1024',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.grey700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.label,
    required this.title,
    required this.body,
  });

  final String label;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.grey600,
            letterSpacing: 0.8,
          ),
        ),
        Gaps.v8,
        Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.grey900,
            fontWeight: FontWeight.w700,
          ),
        ),
        Gaps.v4,
        Text(
          body,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
        ),
      ],
    );
  }
}

class _ItemizedTable extends StatelessWidget {
  const _ItemizedTable({required this.items});

  final List<InvoiceDetailItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TableHeader(),
        ...items.map(_TableRow.new),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.v8,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey300)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              'DESCRIPTION',
              style: _tableHeaderStyle(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'QTY',
              textAlign: TextAlign.center,
              style: _tableHeaderStyle(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'RATE',
              textAlign: TextAlign.right,
              style: _tableHeaderStyle(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'AMOUNT',
              textAlign: TextAlign.right,
              style: _tableHeaderStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow(this.item);

  final InvoiceDetailItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.v16,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v4,
                Text(
                  item.note,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatCurrency(item.rate),
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatCurrency(item.amount),
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary({required this.controller});

  final InvoiceDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Column(
        children: [
          _SummaryLine(
            label: 'Subtotal',
            value: _formatCurrency(controller.subtotal),
          ),
          _SummaryLine(
            label: 'Tax (8%)',
            value: _formatCurrency(controller.tax),
          ),
          const Divider(color: AppColors.grey300),
          _SummaryLine(
            label: 'Total Amount',
            value: _formatCurrency(controller.total),
            isEmphasis: true,
            valueColor: AppColors.primary,
          ),
          Gaps.v8,
          Container(
            padding: AppPadding.h12.add(AppPadding.v8),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _SummaryLine(
              label: 'Amount Paid',
              value: '-${_formatCurrency(controller.amountPaid)}',
              compact: true,
              isEmphasis: true,
              labelColor: AppColors.grey700,
              valueColor: AppColors.grey700,
            ),
          ),
          Gaps.v8,
          _SummaryLine(
            label: 'Balance Due',
            value: _formatCurrency(controller.balanceDue),
            isHeadline: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.isEmphasis = false,
    this.isHeadline = false,
    this.compact = false,
    this.labelColor,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isEmphasis;
  final bool isHeadline;
  final bool compact;
  final Color? labelColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final style = isHeadline
        ? AppTextStyles.headlineMedium
        : compact
            ? AppTextStyles.labelSmall
            : AppTextStyles.bodyMedium;

    return Padding(
      padding: compact ? EdgeInsets.zero : AppPadding.v8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: style.copyWith(
              color: labelColor ?? AppColors.grey600,
              fontWeight: isEmphasis || isHeadline ? FontWeight.w700 : null,
            ),
          ),
          Text(
            value,
            style: style.copyWith(
              color: valueColor ?? AppColors.grey900,
              fontWeight: isEmphasis || isHeadline ? FontWeight.w700 : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.v24,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.grey300, style: BorderStyle.solid),
        ),
      ),
      child: Text(
        'Thank you for your business. Payment was processed via Stripe on Oct 26, 2023.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
      ),
    );
  }
}

class _InvoiceDetailsActionBar extends StatelessWidget {
  const _InvoiceDetailsActionBar({required this.controller});

  final InvoiceDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: AppPadding.h16.add(AppPadding.v16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.ios_share_rounded,
                label: 'Share PDF',
                onPressed: controller.sharePdf,
              ),
            ),
            Expanded(
              child: _ActionButton(
                icon: Icons.print_rounded,
                label: 'Print',
                onPressed: controller.printInvoice,
              ),
            ),
            Expanded(
              child: _ActionButton(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onPressed: controller.editInvoice,
              ),
            ),
            Gaps.h8,
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: controller.addPayment,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    textStyle: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.grey600,
        padding: AppPadding.all8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          Gaps.v4,
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.grey600,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle _tableHeaderStyle() {
  return AppTextStyles.labelSmall.copyWith(
    color: AppColors.grey600,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );
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
