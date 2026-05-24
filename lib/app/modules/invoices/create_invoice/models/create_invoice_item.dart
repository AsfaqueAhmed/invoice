class CreateInvoiceItem {
  const CreateInvoiceItem({
    required this.name,
    required this.sku,
    required this.unitLabel,
    required this.unitPrice,
    required this.quantity,
  });

  final String name;
  final String sku;
  final String unitLabel;
  final double unitPrice;
  final int quantity;

  double get total => unitPrice * quantity;

  CreateInvoiceItem copyWith({
    String? name,
    String? sku,
    String? unitLabel,
    double? unitPrice,
    int? quantity,
  }) {
    return CreateInvoiceItem(
      name: name ?? this.name,
      sku: sku ?? this.sku,
      unitLabel: unitLabel ?? this.unitLabel,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}
