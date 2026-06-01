import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/database/database_service.dart';
import '../../../../data/datasources/local/product_local_datasource.dart';
import '../../../../data/entities/product_entity.dart';
import '../../../../routes/app_pages.dart';

class ProductListController extends GetxController {
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxList<ProductEntity> _allProducts = <ProductEntity>[].obs;

  late final ProductLocalDatasource _datasource;

  // Computed
  String get totalValue {
    final total = _allProducts.fold<double>(
      0,
      (sum, p) => sum + (p.sellingPrice * p.stock),
    );
    return _fmt(total);
  }

  int get lowStockCount =>
      _allProducts.where((p) => p.stock > 0 && p.stock <= 10).length;

  List<ProductEntity> get filtered {
    final q = searchQuery.value.toLowerCase().trim();
    if (q.isEmpty) return _allProducts;
    return _allProducts
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.sku.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _datasource = ProductLocalDatasource(DatabaseService());
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    isLoading(true);
    try {
      _allProducts.value = await _datasource.getAll();
    } catch (_) {
      _allProducts.value = [];
    } finally {
      isLoading(false);
    }
  }

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

  String _fmt(double val) {
    if (val >= 1000) {
      return '\$${val.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    }
    return '\$${val.toStringAsFixed(2)}';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
