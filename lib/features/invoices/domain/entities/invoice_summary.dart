import 'package:flutter_getx_app/app/core/extensions/num_extensions.dart';

/// Read-model for the invoice list screen: an [InvoiceEntity] joined with
/// its customer's name so the UI never has to look the customer up itself.
class InvoiceSummary {
  const InvoiceSummary({
    required this.id,
    required this.invoiceNo,
    required this.customerName,
    required this.total,
    required this.paid,
    required this.due,
    required this.status,
  });

  final String id;
  final String invoiceNo;
  final String customerName;
  final double total;
  final double paid;
  final double due;
  final String status;

  String get formattedTotal => total.asCurrency;

  String get dueTag => due > 0 ? 'Due: ${due.asCurrency}' : 'Cleared';
}
