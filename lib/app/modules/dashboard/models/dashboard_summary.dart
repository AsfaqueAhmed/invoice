import 'package:flutter/material.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.label,
    required this.value,
    required this.detail,
    required this.valueColor,
    this.trend,
    this.trendIcon,
  });

  final String label;
  final String value;
  final String detail;
  final Color valueColor;
  final String? trend;
  final IconData? trendIcon;
}

class DashboardAction {
  const DashboardAction({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
}

class RecentInvoice {
  const RecentInvoice({
    required this.number,
    required this.customerName,
    required this.amount,
    required this.status,
  });

  final String number;
  final String customerName;
  final String amount;
  final String status;
}
