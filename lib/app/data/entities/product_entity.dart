class ProductEntity {
  final String id;
  final String name;
  final String sku;
  final String category;
  final double purchasePrice;
  final double sellingPrice;
  final int stock;
  final String? description;

  ProductEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stock,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'category': category,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'stock': stock,
      'description': description,
    };
  }

  factory ProductEntity.fromJson(
    Map<String, dynamic> map,
  ) {
    return ProductEntity(
      id: map['id'],
      name: map['name'],
      sku: map['sku'],
      category: map['category'],
      purchasePrice: map['purchasePrice'],
      sellingPrice: map['sellingPrice'],
      stock: map['stock'],
      description: map['description'],
    );
  }
}
