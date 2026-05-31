import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/constants/gaps.dart';
import '../../../../core/constants/app_decorations.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../controllers/invoice_details_controller.dart';

class InvoiceDetailsView extends GetView<InvoiceDetailsController> {
  const InvoiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;
    final inv = controller.invoice;

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
          onPressed: Get.back,
        ),
        title: Text(
          'Invoice #${inv['number'] ?? '1024'}',
          style: TextStyle(
              fontWeight: FontWeight.w700, color: colors.primary),
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
              onTap: controller.onShare),
          _ActionBtn(
              icon: Icons.print_outlined,
              label: 'Print',
              colors: colors,
              onTap: controller.onPrint),
          _ActionBtn(
              icon: Icons.edit_outlined,
              label: 'Edit',
              colors: colors,
              onTap: controller.onEdit),
          Gaps.h8,
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: controller.onAddPayment,
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
      body: Column(children: [
        // Status banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: colors.chipGreenBg,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded,
                  color: colors.chipGreenFg, size: 18),
              Gaps.h8,
              Text(
                'Invoice Fully Paid',
                style: TextStyle(
                  color: colors.chipGreenFg,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Date Issued',
                          style: TextStyle(
                            fontSize: 10,
                            color: colors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          inv['date'] ?? 'Oct 24, 2023',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Gaps.v4,
                Text(
                  '123 Financial District, New York, NY 10001',
                  style: TextStyle(
                      fontSize: 12, color: colors.textSecondary),
                ),
                Divider(
                    height: 24,
                    color: colors.outlineVariant.withOpacity(0.5)),

                // Billed to / Payment terms
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
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
                            inv['client'] ?? 'Acme Corp International',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            '456 Business Way\nSan Francisco, CA',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'PAYMENT TERMS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Gaps.v4,
                        Text(
                          'Due on Receipt',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textPrimary,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: AppDecorations.chipDecoration(
                              bg: colors.surfaceContainer),
                          child: Text(
                            '#${inv['number'] ?? '2023-1024'}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700)),
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

                _InvoiceRow('Brand Strategy Workshop', '1', r'$2,500.00',
                    r'$2,500.00', colors),
                _InvoiceRow(
                    'UI/UX Design Kit', '3', r'$450.00', r'$1,350.00', colors),
                _InvoiceRow('Ongoing Consulting', '10', r'$150.00',
                    r'$1,500.00', colors),

                Gaps.v16,

                // Summary
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 240,
                    child: Column(children: [
                      _SummaryRow('Subtotal', r'$5,350.00', colors),
                      _SummaryRow('Tax (8%)', r'$428.00', colors),
                      Divider(
                          color: colors.outlineVariant.withOpacity(0.5)),
                      _SummaryRow('Total Amount', r'$5,778.00', colors,
                          bold: true, valueColor: colors.primary),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: AppDecorations.chipDecoration(
                            bg: colors.surfaceContainer),
                        child: _SummaryRow(
                            'Amount Paid', r'-$5,778.00', colors,
                            small: true),
                      ),
                      _SummaryRow('Balance Due', r'$0.00', colors,
                          bold: true),
                    ]),
                  ),
                ),

                Divider(
                    height: 24,
                    color: colors.outlineVariant.withOpacity(0.5)),
                Text(
                  'Thank you for your business. Payment was processed via Stripe on Oct 26, 2023.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 11, color: colors.textSecondary),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

Widget _InvoiceRow(String desc, String qty, String rate, String amount,
        AppColorBase colors) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(
          flex: 4,
          child: Text(desc,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: colors.textPrimary)),
        ),
        SizedBox(
          width: 24,
          child: Text(qty,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 13, color: colors.textPrimary)),
        ),
        Expanded(
          flex: 2,
          child: Text(rate,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 13, color: colors.textSecondary)),
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

Widget _SummaryRow(String label, String value, AppColorBase colors,
        {bool bold = false, Color? valueColor, bool small = false}) =>
    Padding(
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

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppColorBase colors;
  final VoidCallback onTap;

  const _ActionBtn(
      {required this.icon,
      required this.label,
      required this.colors,
      required this.onTap});

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
