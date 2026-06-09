import '../../domain/models/invoice.dart';

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

  const InvoiceEntity({
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

  factory InvoiceEntity.fromJson(Map<String, dynamic> json) {
    return InvoiceEntity(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      invoiceNo: json['invoiceNo'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      paid: (json['paid'] as num).toDouble(),
      due: (json['due'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

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
      'status': status,
    };
  }

  factory InvoiceEntity.fromDomain(Invoice invoice) {
    return InvoiceEntity(
      id: invoice.id,
      customerId: invoice.customerId,
      invoiceNo: invoice.invoiceNo,
      subtotal: invoice.subtotal,
      discount: invoice.discount,
      tax: invoice.tax,
      total: invoice.total,
      paid: invoice.paid,
      due: invoice.due,
      status: invoice.status,
    );
  }

  Invoice toDomain() {
    return Invoice(
      id: id,
      customerId: customerId,
      invoiceNo: invoiceNo,
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      total: total,
      paid: paid,
      due: due,
      status: status,
    );
  }
}
