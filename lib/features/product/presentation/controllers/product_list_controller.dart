import 'package:flutter/material.dart';
import 'package:flutter_getx_app/core/utils/currency_formatter.dart';
import 'package:get/get.dart';

import '../../domain/models/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductListController extends GetxController {
  final ProductRepository _repository;

  ProductListController(this._repository);

  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxList<Product> _allProducts = <Product>[].obs;

  final RxnBool activeFilter = RxnBool();
  final RxString selectedCategory = ''.obs;
  final Rx<RangeValues> priceRange = const RangeValues(0, 100000).obs;
  final Rx<RangeValues> stockRange = const RangeValues(0, 5000).obs;
  final RxDouble maxPrice = 0.0.obs;
  final RxInt maxStock = 0.obs;
  final Rx<RangeValues> selectedPriceRange = const RangeValues(0, 0).obs;
  final Rx<RangeValues> selectedStockRange = const RangeValues(0, 0).obs;

  static const List<String> categories = [
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

  String get totalValue {
    final total = _allProducts.fold<double>(
        0, (sum, p) => sum + (p.sellingPrice * p.stock));
    return CurrencyFormatter.format(total);
  }

  int get lowStockCount =>
      _allProducts.where((p) => p.stock > 0 && p.stock <= 10).length;

  List<Product> get filtered {
    final q = searchQuery.value.toLowerCase().trim();
    return _allProducts.where((p) {
      final matchesSearch = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.sku.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
      final matchesCategory = selectedCategory.value.isEmpty ||
          selectedCategory.value == 'All' ||
          p.category == selectedCategory.value;
      final matchesActive =
          activeFilter.value == null || p.isActive == activeFilter.value;
      final matchesPrice = p.sellingPrice >= selectedPriceRange.value.start &&
          p.sellingPrice <= selectedPriceRange.value.end;
      final matchesStock = p.stock >= selectedStockRange.value.start &&
          p.stock <= selectedStockRange.value.end;
      return matchesSearch &&
          matchesCategory &&
          matchesActive &&
          matchesPrice &&
          matchesStock;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    selectedCategory.value = categories.first;
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    isLoading(true);
    try {
      _allProducts.value = await _repository.getAll();
      if (_allProducts.isNotEmpty) {
        final highestPrice = _allProducts
            .map((e) => e.sellingPrice)
            .reduce((a, b) => a > b ? a : b);
        final highestStock =
            _allProducts.map((e) => e.stock).reduce((a, b) => a > b ? a : b);
        maxPrice.value = highestPrice;
        maxStock.value = highestStock;
        selectedPriceRange.value = RangeValues(0, highestPrice);
        priceRange.value = RangeValues(0, highestPrice);
        selectedStockRange.value = RangeValues(0, highestStock.toDouble());
        stockRange.value = RangeValues(0, highestStock.toDouble());
      }
    } catch (e, stack) {
      debugPrint('Error loading products: $e\n$stack');
    } finally {
      isLoading(false);
    }
  }

  void onCategorySelect(String cat) => selectedCategory(cat);

  @override
  Future<void> refresh() => _loadProducts();

  void onSearch(String v) => searchQuery(v);

  void onProductTap(Product p) => Get.toNamed('/product-details', arguments: p);

  void onAddProduct() {
    Get.toNamed('/add-product')?.then((result) {
      if (result == true) _loadProducts();
    });
  }

  void toggleActiveFilter() {
    activeFilter.value = !(activeFilter.value ?? false);
  }

  void updatePriceRange(RangeValues values) =>
      selectedPriceRange.value = values;

  void updateStockRange(RangeValues values) =>
      selectedStockRange.value = values;

  double get maxHeight {
    final context = Get.context!;
    return MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
