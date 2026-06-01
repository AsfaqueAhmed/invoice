import 'package:flutter_getx_app/app/data/entities/product_entity.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  final ProductEntity product = Get.arguments as ProductEntity;
/*  final recentInvoices = <Map<String, dynamic>>[
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
  ];*/

  @override
  void onInit() {
    super.onInit();
  }

  void onShare() {}

  void onAddToInvoice() => Get.toNamed(Routes.createInvoice);
}
