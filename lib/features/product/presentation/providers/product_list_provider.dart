import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/extensions/num_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/entities/product_entity.dart';

const productCategories = [
  'All',
  'General',
  'Food',
  'Beverages',
  'Electronics',
  'Computer & IT',
  'Mobile & Accessories',
  'Clothing',
  'Footwear',
  'Beauty & Personal Care',
  'Health & Medicine',
  'Home & Kitchen',
  'Furniture',
  'Books & Stationery',
  'Sports & Fitness',
  'Toys & Games',
  'Automotive',
  'Hardware & Tools',
  'Pet Supplies',
  'Services',
  'Other',
];

/// Search query typed into the product list search field.
final productSearchQueryProvider = StateProvider<String>((ref) => '');

/// The currently applied filter selections from the filter sheet. Price and
/// stock ranges start out `null`, meaning "no filter applied" — the UI falls
/// back to the full `[0, max]` range computed live from the loaded products.
class ProductFilters {
  const ProductFilters({
    this.category = 'All',
    this.activeOnly = false,
    this.priceRange,
    this.stockRange,
  });

  final String category;
  final bool activeOnly;
  final RangeValues? priceRange;
  final RangeValues? stockRange;

  ProductFilters copyWith({
    String? category,
    bool? activeOnly,
    RangeValues? priceRange,
    RangeValues? stockRange,
  }) {
    return ProductFilters(
      category: category ?? this.category,
      activeOnly: activeOnly ?? this.activeOnly,
      priceRange: priceRange ?? this.priceRange,
      stockRange: stockRange ?? this.stockRange,
    );
  }
}

final productFiltersProvider =
    StateProvider<ProductFilters>((ref) => const ProductFilters());

/// Loads all products and keeps the list in sync after creates/updates.
final productListProvider =
    AsyncNotifierProvider<ProductListNotifier, List<ProductEntity>>(
  ProductListNotifier.new,
);

class ProductListNotifier extends AsyncNotifier<List<ProductEntity>> {
  @override
  Future<List<ProductEntity>> build() {
    return ref.watch(productRepositoryProvider).getAll();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(productRepositoryProvider).getAll(),
    );
  }
}

/// Highest selling price among loaded products — the upper bound for the
/// price range slider.
final productMaxPriceProvider = Provider<double>((ref) {
  final products = ref.watch(productListProvider).valueOrNull ?? [];
  if (products.isEmpty) return 0;
  return products.map((p) => p.sellingPrice).reduce((a, b) => a > b ? a : b);
});

/// Highest stock count among loaded products — the upper bound for the
/// stock range slider.
final productMaxStockProvider = Provider<int>((ref) {
  final products = ref.watch(productListProvider).valueOrNull ?? [];
  if (products.isEmpty) return 0;
  return products.map((p) => p.stock).reduce((a, b) => a > b ? a : b);
});

/// Products filtered by search query, category, active state, price and
/// stock ranges — everything the filter sheet and search field can apply.
final filteredProductsProvider = Provider<List<ProductEntity>>((ref) {
  final products = ref.watch(productListProvider).valueOrNull ?? [];
  final query = ref.watch(productSearchQueryProvider).toLowerCase().trim();
  final filters = ref.watch(productFiltersProvider);
  final priceRange =
      filters.priceRange ?? RangeValues(0, ref.watch(productMaxPriceProvider));
  final stockRange = filters.stockRange ??
      RangeValues(0, ref.watch(productMaxStockProvider).toDouble());

  return products.where((p) {
    final matchesSearch = query.isEmpty ||
        p.name.toLowerCase().contains(query) ||
        p.sku.toLowerCase().contains(query) ||
        p.category.toLowerCase().contains(query);

    final matchesCategory =
        filters.category == 'All' || p.category == filters.category;

    final matchesActive = !filters.activeOnly || p.isProductActive;

    final matchesPrice =
        p.sellingPrice >= priceRange.start && p.sellingPrice <= priceRange.end;
    final matchesStock =
        p.stock >= stockRange.start && p.stock <= stockRange.end;

    return matchesSearch &&
        matchesCategory &&
        matchesActive &&
        matchesPrice &&
        matchesStock;
  }).toList();
});

/// Combined sale value of every product's remaining stock, formatted as
/// currency, for the stats header.
final totalProductValueProvider = Provider<String>((ref) {
  final products = ref.watch(productListProvider).valueOrNull ?? [];
  final total = products.fold<double>(0, (sum, p) => sum + p.sellingPrice * p.stock);
  return total.asCurrency;
});

/// Number of products that are running low (but not yet out of) stock.
final lowStockCountProvider = Provider<int>((ref) {
  final products = ref.watch(productListProvider).valueOrNull ?? [];
  return products.where((p) => p.stock > 0 && p.stock <= 10).length;
});
