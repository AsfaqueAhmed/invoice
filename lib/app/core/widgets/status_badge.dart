import 'package:flutter/material.dart';
import '../configs/theme/app_colors.dart';
import '../constants/app_decorations.dart';

enum InvoiceStatus { paid, pending, partial, due, overdue }

class StatusBadge extends StatelessWidget {
  final InvoiceStatus status;

  const StatusBadge({super.key, required this.status});

  static InvoiceStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'paid':
        return InvoiceStatus.paid;
      case 'partial':
        return InvoiceStatus.partial;
      case 'due':
        return InvoiceStatus.due;
      case 'overdue':
        return InvoiceStatus.overdue;
      default:
        return InvoiceStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final Color bg;
    final Color fg;
    final String label;

    switch (status) {
      case InvoiceStatus.paid:
        bg = colors.chipGreenBg;
        fg = colors.chipGreenFg;
        label = 'Paid';
        break;
      case InvoiceStatus.partial:
        bg = colors.chipAmberBg;
        fg = colors.chipAmberFg;
        label = 'Partial';
        break;
      case InvoiceStatus.due:
        bg = colors.chipRedBg;
        fg = colors.chipRedFg;
        label = 'Due';
        break;
      case InvoiceStatus.overdue:
        bg = colors.chipRedBg;
        fg = colors.error;
        label = 'Overdue';
        break;
      case InvoiceStatus.pending:
        bg = colors.chipAmberBg;
        fg = colors.chipAmberFg;
        label = 'Pending';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: AppDecorations.chipDecoration(bg: bg),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
