class InvoiceEntity {
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

  InvoiceEntity({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'invoiceNo': invoiceNo,
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'total': total,
      'paid': paid,
      'due': due,
      'status': status
    };
  }

  factory InvoiceEntity.fromJson(
    Map<String, dynamic> map,
  ) {
    return InvoiceEntity(
        id: map['id'],
        customerId: map['customerId'],
        invoiceNo: map['invoiceNo'],
        subtotal: map['subtotal'],
        discount: map['discount'],
        tax: map['tax'],
        total: map['total'],
        paid: map['paid'],
        due: map['due'],
        status: map['status']);
  }
}
