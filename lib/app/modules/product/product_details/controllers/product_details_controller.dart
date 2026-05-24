import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  late final Map<String, dynamic> product;
  final recentInvoices = <Map<String, dynamic>>[
    {
      'number': 'INV-2024-001',
      'date': 'Mar 12, 2024',
      'qty': 12,
      'amount': r'$1,068.00',
      'status': 'paid'
    },
    {
      'number': 'INV-2024-005',
      'date': 'Mar 08, 2024',
      'qty': 5,
      'amount': r'$445.00',
      'status': 'pending'
    },
  ];

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments as Map<String, dynamic>? ??
        {
          'name': 'Premium Laptop Stand',
          'sku': 'PLS-990-BLK',
          'stock': 450,
          'price': r'$89.00',
          'status': 'instock'
        };
  }

  void onShare() {}

  void onAddToInvoice() => Get.toNamed(Routes.createInvoice);
}
