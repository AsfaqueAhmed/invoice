class InvoiceDetailItem {
  const InvoiceDetailItem({
    required this.description,
    required this.note,
    required this.quantity,
    required this.rate,
  });

  final String description;
  final String note;
  final int quantity;
  final double rate;

  double get amount => quantity * rate;
}
