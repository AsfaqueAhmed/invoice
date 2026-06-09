class Invoice {
  final String id;
  final String customerId;
  final String invoiceNo;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final double paid;
  final double due;
  final String status;

  const Invoice({
    required this.id,
    required this.customerId,
    required this.invoiceNo,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paid,
    required this.due,
    required this.status,
  });

  Invoice copyWith({
    String? id,
    String? customerId,
    String? invoiceNo,
    double? subtotal,
    double? discount,
    double? tax,
    double? total,
    double? paid,
    double? due,
    String? status,
  }) {
    return Invoice(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      paid: paid ?? this.paid,
      due: due ?? this.due,
      status: status ?? this.status,
    );
  }
}
