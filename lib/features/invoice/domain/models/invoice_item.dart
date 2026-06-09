class InvoiceItem {
  final String id;
  final String invoiceId;
  final String productId;
  final String name;
  final int qty;
  final double price;
  final double total;

  const InvoiceItem({
    required this.id,
    required this.invoiceId,
    required this.productId,
    required this.name,
    required this.qty,
    required this.price,
    required this.total,
  });
}
