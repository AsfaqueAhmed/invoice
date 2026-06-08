import 'package:get/get.dart';
import '../../../../data/repositories/customer_repository.dart';
import '../controllers/add_customer_controller.dart';
class AddCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCustomerController>(() => AddCustomerController(Get.find<CustomerRepository>()));
  }
}
