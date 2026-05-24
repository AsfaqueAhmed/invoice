import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final totalValue = r'$124,500';
  final lowStockCount = 12;
  final allProducts = <Map<String, dynamic>>[
    {
      'name': 'Premium Laptop Stand',
      'sku': 'PLS-990-BLK',
      'stock': 450,
      'price': r'$89.00',
      'status': 'instock'
    },
    {
      'name': 'Wireless Ergo Mouse',
      'sku': 'WEM-102-SLV',
      'stock': 8,
      'price': r'$55.00',
      'status': 'lowstock'
    },
    {
      'name': 'Mechanical Keyboard V2',
      'sku': 'MKV2-RGB-PRO',
      'stock': 0,
      'price': r'$149.50',
      'status': 'outofstock'
    },
    {
      'name': 'USB-C Hub 8-in-1',
      'sku': 'HUB-81-GRY',
      'stock': 1240,
      'price': r'$42.99',
      'status': 'instock'
    },
  ].obs;

  List<Map<String, dynamic>> get filtered {
    final q = searchQuery.value.toLowerCase();
    if (q.isEmpty) return allProducts;
    return allProducts
        .where((p) =>
            (p['name'] as String).toLowerCase().contains(q) ||
            (p['sku'] as String).toLowerCase().contains(q))
        .toList();
  }

  void onSearch(String v) => searchQuery(v);

  void onProductTap(Map<String, dynamic> p) =>
      Get.toNamed(Routes.PRODUCT_DETAILS, arguments: p);

  void onAddProduct() => Get.toNamed(Routes.ADD_PRODUCT);

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
