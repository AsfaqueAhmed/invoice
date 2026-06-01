class ProductEntity {
  final String id;
  final String name;
  final String sku;
  final String category;
  final double purchasePrice;
  final double sellingPrice;
  final int stock;
  final String? description;
  final String? image;
  final bool isProductActive;

  ProductEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stock,
    this.description,
    this.image,
    required this.isProductActive,
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
      'image': image,
      'isProductActive': isProductActive ? 1 : 0,
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
      description: map['description']??'',
      image: map['image']??'',
      isProductActive: map['isProductActive'] == 1,
    );
  }
}
