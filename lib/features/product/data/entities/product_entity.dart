import '../../domain/models/product.dart';

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
  final bool isActive;

  const ProductEntity({
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

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      category: json['category'] as String,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      stock: json['stock'] as int,
      description: json['description'] as String?,
      image: json['image'] as String?,
      isActive: json['isProductActive'] == 1,
    );
  }

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
      'isProductActive': isActive ? 1 : 0,
    };
  }

  factory ProductEntity.fromDomain(Product product) {
    return ProductEntity(
      id: product.id,
      name: product.name,
      sku: product.sku,
      category: product.category,
      purchasePrice: product.purchasePrice,
      sellingPrice: product.sellingPrice,
      stock: product.stock,
      description: product.description,
      image: product.image,
      isActive: product.isActive,
    );
  }

  Product toDomain() {
    return Product(
      id: id,
      name: name,
      sku: sku,
      category: category,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      stock: stock,
      description: description,
      image: image,
      isActive: isActive,
    );
  }
}
