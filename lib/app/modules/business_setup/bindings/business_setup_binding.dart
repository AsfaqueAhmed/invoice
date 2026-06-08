import 'package:get/get.dart';
import '../../../data/repositories/business_repository.dart';
import '../controllers/business_setup_controller.dart';
class BusinessSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessSetupController>(() => BusinessSetupController(Get.find<BusinessRepository>()));
  }
}
