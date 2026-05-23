class ProductModel {
  final String id;
  final String name;
  final String sku;
  final String? barcode;
  final double price;
  final int stockQty;
  final ProductCategory category;
  final String? description;
  final String? imageUrl;
  final double taxRate;
  final List<ProductInvoice> recentInvoices;

  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    this.barcode,
    required this.price,
    required this.stockQty,
    required this.category,
    this.description,
    this.imageUrl,
    this.taxRate = 8.5,
    this.recentInvoices = const [],
  });

  StockStatus get stockStatus {
    if (stockQty == 0) return StockStatus.outOfStock;
    if (stockQty < 10) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  double get totalInventoryValue => price * stockQty;
}

enum ProductCategory { beverages, bakery, dairy, merchandise, hardware, accessories, other }

extension ProductCategoryExt on ProductCategory {
  String get label {
    switch (this) {
      case ProductCategory.beverages:
        return 'Beverages';
      case ProductCategory.bakery:
        return 'Bakery';
      case ProductCategory.dairy:
        return 'Dairy';
      case ProductCategory.merchandise:
        return 'Merchandise';
      case ProductCategory.hardware:
        return 'Hardware / Accessories';
      case ProductCategory.accessories:
        return 'Accessories';
      case ProductCategory.other:
        return 'Other';
    }
  }
}

enum StockStatus { inStock, lowStock, outOfStock }

extension StockStatusExt on StockStatus {
  String get label {
    switch (this) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }
}

class ProductInvoice {
  final String invoiceNumber;
  final double amount;
  final int units;
  final DateTime date;
  final String status;

  ProductInvoice({
    required this.invoiceNumber,
    required this.amount,
    required this.units,
    required this.date,
    required this.status,
  });
}
