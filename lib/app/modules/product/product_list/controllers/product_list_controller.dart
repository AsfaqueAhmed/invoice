import 'package:flutter_getx_app/app/modules/product/product_list/model/product_model.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final Rx<ProductCategory?> selectedCategory = Rx<ProductCategory?>(null);
  @override
  void onInit() {
    _loadMockProducts();
    ever(searchQuery, (_) => _filterProducts());
    ever(selectedCategory, (_) => _filterProducts());
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  void _loadMockProducts() {
    isLoading.value = true;
    final mockData = [
      ProductModel(
        id: '1',
        name: 'Premium Laptop Stand',
        sku: 'PLS-990-BLK',
        price: 89.00,
        stockQty: 450,
        category: ProductCategory.hardware,
        description:
        'Sleek aluminum laptop stand with adjustable height and cooling vents. Compatible with all laptops up to 16 inches.',
        taxRate: 8.5,
        recentInvoices: [
          ProductInvoice(
            invoiceNumber: 'INV-2024-001',
            amount: 1068.00,
            units: 12,
            date: DateTime(2024, 3, 12),
            status: 'PAID',
          ),
          ProductInvoice(
            invoiceNumber: 'INV-2024-005',
            amount: 445.00,
            units: 5,
            date: DateTime(2024, 3, 8),
            status: 'PENDING',
          ),
        ],
      ),
      ProductModel(
        id: '2',
        name: 'Wireless Ergo Mouse',
        sku: 'WEM-102-SLV',
        price: 55.00,
        stockQty: 8,
        category: ProductCategory.accessories,
        description: 'Ergonomic wireless mouse with 2.4GHz receiver and 18-month battery life.',
        taxRate: 8.5,
      ),
      ProductModel(
        id: '3',
        name: 'Mechanical Keyboard V2',
        sku: 'MKV2-RGB-PRO',
        price: 149.50,
        stockQty: 0,
        category: ProductCategory.accessories,
        description: 'Compact TKL mechanical keyboard with RGB backlight and tactile switches.',
        taxRate: 8.5,
      ),
      ProductModel(
        id: '4',
        name: 'USB-C Hub 8-in-1',
        sku: 'HUB-31-GRY',
        price: 42.00,
        stockQty: 65,
        category: ProductCategory.accessories,
        description: '8-in-1 USB-C hub with 4K HDMI, SD card, USB-A, and PD charging.',
        taxRate: 8.5,
      ),
    ];
    products.assignAll(mockData);
    filteredProducts.assignAll(mockData);
    isLoading.value = false;
  }
  void _filterProducts() {
    var result = products.toList();
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result
          .where((p) =>
      p.name.toLowerCase().contains(q) ||
          p.sku.toLowerCase().contains(q))
          .toList();
    }
    if (selectedCategory.value != null) {
      result = result.where((p) => p.category == selectedCategory.value).toList();
    }
    filteredProducts.assignAll(result);
  }
  void selectProduct(ProductModel product) {
    Get.toNamed(Routes.PRODUCT_DETAILS,arguments: product);
  }

  double get totalInventoryValue =>
      products.fold(0, (sum, p) => sum + p.totalInventoryValue);

  int get lowStockCount =>
      products.where((p) => p.stockStatus == StockStatus.lowStock).length;

}
