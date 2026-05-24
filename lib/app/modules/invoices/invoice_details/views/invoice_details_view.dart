import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bar.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:get/get.dart';

import '../controllers/invoice_details_controller.dart';

class InvoiceDetailsView extends GetView<InvoiceDetailsController> {
  const InvoiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomAppAppbar(
        title: 'Invoice #1024',
        action: [
          Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 12),
              decoration: const BoxDecoration(
                  color: AppColor.primaryFixed, shape: BoxShape.circle),
              child: Icon(Icons.business_rounded, color: cs.primary, size: 20))
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurfaceContainer : Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4))
            ]),
        child: Row(children: [
          _ActionBtn(
              icon: Icons.share_outlined,
              label: 'Share PDF',
              onTap: controller.onShare),
          _ActionBtn(
              icon: Icons.print_outlined,
              label: 'Print',
              onTap: controller.onPrint),
          _ActionBtn(
              icon: Icons.edit_outlined,
              label: 'Edit',
              onTap: controller.onEdit),
          const SizedBox(width: 8),
          Expanded(
              child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                      onPressed: controller.onAddPayment,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Payment')))),
        ]),
      ),
      body: Column(children: [
        Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: AppColor.successBg,
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: AppColor.successText, size: 18),
                  SizedBox(width: 8),
                  Text('Invoice Fully Paid',
                      style: TextStyle(
                          color: AppColor.successText,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          fontSize: 12)),
                ])),
        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: AppCard(
                    radius: 16,
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('InvoiceFlow',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: cs.primary)),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Date Issued',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: cs.onSurfaceVariant,
                                          letterSpacing: 0.5)),
                                  const Text('Oct 24, 2023',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ]),
                          ]),
                      const SizedBox(height: 4),
                      Text('123 Financial District, New York, NY 10001',
                          style: TextStyle(
                              fontSize: 12, color: cs.onSurfaceVariant)),
                      Divider(height: 24, color: cs.outlineVariant),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text('BILLED TO',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: cs.onSurfaceVariant,
                                          letterSpacing: 0.8)),
                                  const SizedBox(height: 4),
                                  const Text('Acme Corp International',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  Text(
                                      'Sarah Jenkins\n456 Business Way\nSan Francisco, CA',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: cs.onSurfaceVariant)),
                                ])),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('PAYMENT TERMS',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: cs.onSurfaceVariant,
                                          letterSpacing: 0.8)),
                                  const SizedBox(height: 4),
                                  const Text('Due on Receipt',
                                      style: TextStyle(fontSize: 12)),
                                  Container(
                                      margin: const EdgeInsets.only(top: 6),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: cs.surfaceContainer,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text('INV-2023-1024',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: cs.secondary))),
                                ]),
                          ]),
                      const SizedBox(height: 20),
                      // Table header
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: cs.outlineVariant))),
                          child: const Row(children: [
                            Expanded(
                                flex: 4,
                                child: Text('Description',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700))),
                            SizedBox(
                                width: 4,
                                child: Text('Qty',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700))),
                            Expanded(
                                flex: 2,
                                child: Text('Rate',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700))),
                            Expanded(
                                flex: 2,
                                child: Text('Amount',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700))),
                          ])),
                      _InvoiceRow('Brand Strategy Workshop', '1', r'$2,500.00',
                          r'$2,500.00', cs),
                      _InvoiceRow('UI/UX Design Kit', '3', r'$450.00',
                          r'$1,350.00', cs),
                      _InvoiceRow('Ongoing Consulting', '10', r'$150.00',
                          r'$1,500.00', cs),
                      const SizedBox(height: 16),
                      // Summary
                      Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                              width: 240,
                              child: Column(children: [
                                _SummaryRow('Subtotal', r'$5,350.00', cs),
                                _SummaryRow('Tax (8%)', r'$428.00', cs),
                                Divider(color: cs.outlineVariant),
                                _SummaryRow('Total Amount', r'$5,778.00', cs,
                                    bold: true, valueColor: cs.primary),
                                Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                        color: cs.surfaceContainer,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: _SummaryRow(
                                        'Amount Paid', '-\$5,778.00', cs,
                                        small: true)),
                                _SummaryRow('Balance Due', r'$0.00', cs,
                                    bold: true),
                              ]))),
                      Divider(height: 24, color: cs.outlineVariant),
                      Text(
                          'Thank you for your business. Payment was processed via Stripe on Oct 26, 2023.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 11, color: cs.onSurfaceVariant)),
                    ])))),
      ]),
    );
  }
}

Widget _InvoiceRow(
        String desc, String qty, String rate, String amount, ColorScheme cs) =>
    Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Expanded(
              flex: 4,
              child: Text(desc,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13))),
          SizedBox(
              width: 24,
              child: Text(qty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13))),
          Expanded(
              flex: 2,
              child: Text(rate,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant))),
          Expanded(
              flex: 2,
              child: Text(amount,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600))),
        ]));

Widget _SummaryRow(String label, String value, ColorScheme cs,
        {bool bold = false, Color? valueColor, bool small = false}) =>
    Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label,
              style: TextStyle(
                  fontSize: small ? 11 : 13,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                  color: cs.onSurfaceVariant)),
          Text(value,
              style: TextStyle(
                  fontSize: small ? 11 : 13,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                  color: valueColor ?? cs.onSurface)),
        ]));

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionBtn(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
        child: GestureDetector(
            onTap: onTap,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, color: cs.secondary, size: 22),
              const SizedBox(height: 2),
              Text(label,
                  style: TextStyle(
                      fontSize: 10,
                      color: cs.secondary,
                      fontWeight: FontWeight.w600)),
            ])));
  }
}
