import 'package:get/get.dart';
import '../../../../data/repositories/product_repository.dart';
import '../controllers/product_list_controller.dart';
class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductListController>(() => ProductListController(Get.find<ProductRepository>()));
  }
}
