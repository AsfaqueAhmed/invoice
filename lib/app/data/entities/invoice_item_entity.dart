class InvoiceItemEntity {
  final String id;
  final String invoiceId;
  final String productId;
  final String name;
  final int qty;
  final double price;
  final double total;

  InvoiceItemEntity({
    required this.id,
    required this.invoiceId,
    required this.productId,
    required this.name,
    required this.qty,
    required this.price,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'productId': productId,
      'name': name,
      'qty': qty,
      'price': price,
      'total': total
    };
  }

  factory InvoiceItemEntity.fromJson(
    Map<String, dynamic> map,
  ) {
    return InvoiceItemEntity(
        id: map['id'],
        invoiceId: map['invoiceId'],
        productId: map['productId'],
        name: map['name'],
        qty: map['qty'],
        price: map['price'],
        total: map['total']);
  }
}
