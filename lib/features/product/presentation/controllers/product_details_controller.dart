import 'package:get/get.dart';

import '../../domain/models/product.dart';

class ProductDetailsController extends GetxController {
  final Product product = Get.arguments as Product;

  void onAddToInvoice() => Get.toNamed('/create-invoice');

  void onEdit() => Get.toNamed('/add-product', arguments: product);
}
