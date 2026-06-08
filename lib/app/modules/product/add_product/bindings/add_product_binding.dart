import 'package:get/get.dart';
import '../../../../data/repositories/product_repository.dart';
import '../controllers/add_product_controller.dart';
class AddProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddProductController>(() => AddProductController(Get.find<ProductRepository>()));
  }
}
