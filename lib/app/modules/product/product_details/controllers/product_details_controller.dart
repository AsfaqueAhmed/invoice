import 'package:flutter_getx_app/app/data/entities/product_entity.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  final ProductEntity product = Get.arguments as ProductEntity;

  @override
  void onInit() {
    super.onInit();
  }

  void onShare() {}

  void onAddToInvoice() => Get.toNamed(Routes.createInvoice);

  void onEdit() {
    Get.toNamed(Routes.ADD_PRODUCT, arguments: product);
  }
}
