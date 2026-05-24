import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';

enum InvoiceStatus { paid, pending, partial, due, overdue }

class StatusBadge extends StatelessWidget {
  final InvoiceStatus status;
  const StatusBadge({super.key, required this.status});

  static InvoiceStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'paid': return InvoiceStatus.paid;
      case 'partial': return InvoiceStatus.partial;
      case 'due': return InvoiceStatus.due;
      case 'overdue': return InvoiceStatus.overdue;
      default: return InvoiceStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      InvoiceStatus.paid    => (AppColor.successBg, AppColor.successText, 'Paid'),
      InvoiceStatus.partial => (AppColor.warningBg, AppColor.warningText, 'Partial'),
      InvoiceStatus.due     => (const Color(0xFFFFF1F2), const Color(0xFFBE123C), 'Due'),
      InvoiceStatus.overdue => (AppColor.errorContainer, AppColor.error, 'Overdue'),
      InvoiceStatus.pending => (AppColor.warningBg, AppColor.warningText, 'Pending'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg, letterSpacing: 0.6)),
    );
  }
}