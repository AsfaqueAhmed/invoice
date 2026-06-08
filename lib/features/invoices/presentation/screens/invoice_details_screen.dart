import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/extensions/num_extensions.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/invoice_details_provider.dart';

class InvoiceDetailsScreen extends ConsumerWidget {
  const InvoiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final invoiceId = Get.arguments as String;
    final details = ref.watch(invoiceDetailsProvider(invoiceId));

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
          onPressed: Get.back,
        ),
        title: Text(
          details.maybeWhen(
            data: (d) => 'Invoice #${d.invoice.invoiceNo}',
            orElse: () => 'Invoice',
          ),
          style: TextStyle(fontWeight: FontWeight.w700, color: colors.primary),
        ),
        actions: [
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child:
                Icon(Icons.business_rounded, color: colors.primary, size: 20),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        decoration: BoxDecoration(
          color: colors.cardBg,
          boxShadow: AppDecorations.bottomSheetShadow,
        ),
        child: Row(children: [
          _ActionBtn(
              icon: Icons.share_outlined,
              label: 'Share PDF',
              colors: colors,
              onTap: () {}),
          _ActionBtn(
              icon: Icons.print_outlined,
              label: 'Print',
              colors: colors,
              onTap: () {}),
          _ActionBtn(
              icon: Icons.edit_outlined,
              label: 'Edit',
              colors: colors,
              onTap: Get.back),
          Gaps.h8,
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed(Routes.ADD_PAYMENT),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDecorations.borderRadiusMD,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      body: details.when(
        loading: () => Center(child: CircularProgressIndicator(color: colors.primary)),
        error: (error, _) => Center(
          child: Text('Could not load this invoice.',
              style: TextStyle(color: colors.textSecondary)),
        ),
        data: (d) => _InvoiceDetailsBody(details: d, colors: colors),
      ),
    );
  }
}

class _InvoiceDetailsBody extends StatelessWidget {
  const _InvoiceDetailsBody({required this.details, required this.colors});

  final InvoiceDetails details;
  final AppColorBase colors;

  @override
  Widget build(BuildContext context) {
    final invoice = details.invoice;
    final customer = details.customer;
    final banner = _statusBanner(invoice.status, colors);

    return Column(children: [
      // Status banner
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: banner.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(banner.icon, color: banner.foreground, size: 18),
            Gaps.h8,
            Text(
              banner.label,
              style: TextStyle(
                color: banner.foreground,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),

      // Invoice card
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AppCard(
            radius: 16,
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'InvoiceFlow',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration:
                        AppDecorations.chipDecoration(bg: colors.surfaceContainer),
                    child: Text(
                      '#${invoice.invoiceNo}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                  height: 24, color: colors.outlineVariant.withOpacity(0.5)),

              // Billed to
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BILLED TO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Gaps.v4,
                    Text(
                      customer?.name ?? 'Unknown customer',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    if (customer != null)
                      Text(
                        '${customer.phone}\n${customer.address}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),

              Gaps.v20,

              // Table header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: colors.outlineVariant.withOpacity(0.5)),
                  ),
                ),
                child: Row(children: [
                  Expanded(
                    flex: 4,
                    child: Text('Description',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        )),
                  ),
                  const SizedBox(
                    width: 24,
                    child: Text('Qty',
                        style:
                            TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Rate',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Amount',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        )),
                  ),
                ]),
              ),

              for (final item in details.items)
                _InvoiceRow(
                  description: item.name,
                  qty: '${item.qty}',
                  rate: item.price.asCurrency,
                  amount: item.total.asCurrency,
                  colors: colors,
                ),

              Gaps.v16,

              // Summary
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 240,
                  child: Column(children: [
                    _SummaryRow('Subtotal', invoice.subtotal.asCurrency, colors),
                    if (invoice.discount > 0)
                      _SummaryRow('Discount', '${invoice.discount}%', colors),
                    Divider(color: colors.outlineVariant.withOpacity(0.5)),
                    _SummaryRow('Total Amount', invoice.total.asCurrency, colors,
                        bold: true, valueColor: colors.primary),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration:
                          AppDecorations.chipDecoration(bg: colors.surfaceContainer),
                      child: _SummaryRow(
                          'Amount Paid', invoice.paid.asCurrency, colors,
                          small: true),
                    ),
                    _SummaryRow('Balance Due', invoice.due.asCurrency, colors,
                        bold: true),
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ),
    ]);
  }

  _StatusBanner _statusBanner(String status, AppColorBase colors) {
    switch (status) {
      case 'paid':
        return _StatusBanner(
          background: colors.chipGreenBg,
          foreground: colors.chipGreenFg,
          icon: Icons.check_circle_rounded,
          label: 'Invoice Fully Paid',
        );
      case 'partial':
        return _StatusBanner(
          background: colors.chipAmberBg,
          foreground: colors.chipAmberFg,
          icon: Icons.hourglass_bottom_rounded,
          label: 'Partially Paid',
        );
      case 'overdue':
        return _StatusBanner(
          background: colors.chipRedBg,
          foreground: colors.chipRedFg,
          icon: Icons.error_outline_rounded,
          label: 'Invoice Overdue',
        );
      default:
        return _StatusBanner(
          background: colors.chipGrayBg,
          foreground: colors.chipGrayFg,
          icon: Icons.schedule_rounded,
          label: 'Payment Pending',
        );
    }
  }
}

class _StatusBanner {
  const _StatusBanner({
    required this.background,
    required this.foreground,
    required this.icon,
    required this.label,
  });

  final Color background;
  final Color foreground;
  final IconData icon;
  final String label;
}

class _InvoiceRow extends StatelessWidget {
  const _InvoiceRow({
    required this.description,
    required this.qty,
    required this.rate,
    required this.amount,
    required this.colors,
  });

  final String description;
  final String qty;
  final String rate;
  final String amount;
  final AppColorBase colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(
          flex: 4,
          child: Text(description,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: colors.textPrimary)),
        ),
        SizedBox(
          width: 24,
          child: Text(qty,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: colors.textPrimary)),
        ),
        Expanded(
          flex: 2,
          child: Text(rate,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, color: colors.textSecondary)),
        ),
        Expanded(
          flex: 2,
          child: Text(amount,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary)),
        ),
      ]),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, this.colors,
      {this.bold = false, this.valueColor, this.small = false});

  final String label;
  final String value;
  final AppColorBase colors;
  final bool bold;
  final Color? valueColor;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: small ? 11 : 13,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                  color: colors.textSecondary)),
          Text(value,
              style: TextStyle(
                  fontSize: small ? 11 : 13,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                  color: valueColor ?? colors.textPrimary)),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final AppColorBase colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: colors.textSecondary, size: 22),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
