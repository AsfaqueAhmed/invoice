import '../../domain/models/invoice_item.dart';

class InvoiceItemEntity {
  final String id;
  final String invoiceId;
  final String productId;
  final String name;
  final int qty;
  final double price;
  final double total;

  const InvoiceItemEntity({
    required this.id,
    required this.invoiceId,
    required this.productId,
    required this.name,
    required this.qty,
    required this.price,
    required this.total,
  });

  factory InvoiceItemEntity.fromJson(Map<String, dynamic> json) {
    return InvoiceItemEntity(
      id: json['id'] as String,
      invoiceId: json['invoiceId'] as String,
      productId: json['productId'] as String,
      name: json['name'] as String,
      qty: json['qty'] as int,
      price: (json['price'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'productId': productId,
      'name': name,
      'qty': qty,
      'price': price,
      'total': total,
    };
  }

  factory InvoiceItemEntity.fromDomain(InvoiceItem item) {
    return InvoiceItemEntity(
      id: item.id,
      invoiceId: item.invoiceId,
      productId: item.productId,
      name: item.name,
      qty: item.qty,
      price: item.price,
      total: item.total,
    );
  }

  InvoiceItem toDomain() {
    return InvoiceItem(
      id: id,
      invoiceId: invoiceId,
      productId: productId,
      name: name,
      qty: qty,
      price: price,
      total: total,
    );
  }
}
