class Product {
  final String id;
  final String name;
  final String sku;
  final String category;
  final double purchasePrice;
  final double sellingPrice;
  final int stock;
  final String? description;
  final String? image;
  final bool isActive;

  const Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stock,
    this.description,
    this.image,
    required this.isActive,
  });

  Product copyWith({
    String? id,
    String? name,
    String? sku,
    String? category,
    double? purchasePrice,
    double? sellingPrice,
    int? stock,
    String? description,
    String? image,
    bool? isActive,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
    );
  }
}
