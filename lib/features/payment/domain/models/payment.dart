class Payment {
  final String id;
  final String invoiceId;
  final double amount;
  final String method;
  final String note;

  const Payment({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.method,
    required this.note,
  });
}
