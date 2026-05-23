import 'package:flutter/material.dart';

enum InvoiceStatus {
  paid,
  partial,
  due,
  overdue,
}

class InvoiceItem {
  const InvoiceItem({
    required this.number,
    required this.date,
    required this.customerName,
    required this.projectName,
    required this.amount,
    required this.status,
    required this.trailingAction,
    required this.trailingIcon,
  });

  final String number;
  final String date;
  final String customerName;
  final String projectName;
  final double amount;
  final InvoiceStatus status;
  final String trailingAction;
  final IconData trailingIcon;
}
