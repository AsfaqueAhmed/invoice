import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/modules/product/product_list/views/widgets/filter_product_widget.dart';
import 'package:get/get.dart';

import '../../../../core/extensions/num_extensions.dart';
import '../../../../data/entities/product_entity.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../../routes/app_pages.dart';

class ProductListController extends GetxController {
  ProductListController(this._repository);

  final ProductRepository _repository;

  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxList<ProductEntity> _allProducts = <ProductEntity>[].obs;

  final RxnBool activeFilter = RxnBool();
  final categories = [
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
  final RxString selectedCategory = ''.obs;
  final Rx<RangeValues> priceRange = const RangeValues(0, 100000).obs;
  final Rx<RangeValues> stockRange = const RangeValues(0, 5000).obs;
  final RxDouble maxPrice = 0.0.obs;
  final RxInt maxStock = 0.obs;
  final Rx<RangeValues> selectedPriceRange = const RangeValues(0, 0).obs;
  final Rx<RangeValues> selectedStockRange = const RangeValues(0, 0).obs;

  // Computed
  String get totalValue {
    final total = _allProducts.fold<double>(
      0,
      (sum, p) => sum + (p.sellingPrice * p.stock),
    );
    return total.asCurrency;
  }

  int get lowStockCount =>
      _allProducts.where((p) => p.stock > 0 && p.stock <= 10).length;

  List<ProductEntity> get filtered {
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
          activeFilter.value == null || p.isProductActive == activeFilter.value;

      // Price
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

        selectedPriceRange.value = RangeValues(
          0,
          highestPrice,
        );
        priceRange.value = RangeValues(
          0,
          highestPrice.toDouble(),
        );

        maxStock.value = highestStock;
        selectedStockRange.value = RangeValues(
          0,
          highestStock.toDouble(),
        );
        stockRange.value = RangeValues(
          0,
          highestStock.toDouble(),
        );
      }
    } catch (e, stack) {
      debugPrint('Error loading products: $e');
      debugPrintStack(stackTrace: stack);
    } finally {
      isLoading(false);
    }
  }

  void onCategorySelect(String cat) => selectedCategory(cat);

  Future<void> refresh() => _loadProducts();

  void onSearch(String v) => searchQuery(v);

  void onProductTap(ProductEntity p) {
    Get.toNamed(Routes.PRODUCT_DETAILS, arguments: p);
  }

  void onAddProduct() {
    Get.toNamed(Routes.ADD_PRODUCT)?.then((value) {
      if (value == true) {
        _loadProducts();
      }
    });
  }

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

  void _showBottomSheet(Widget child) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxHeight: maxHeight),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => child,
    );
  }

  void onFilterClick() {
    _showBottomSheet(FilterProductWidget(
      controller: this,
    ));
  }

  void toggleProduct() {
    activeFilter.value = !(activeFilter.value ?? false);
  }

  void updatePriceRange(RangeValues values) {
    selectedPriceRange.value = values;
  }

  void updateStockRange(RangeValues values) {
    selectedStockRange.value = values;
  }
}
