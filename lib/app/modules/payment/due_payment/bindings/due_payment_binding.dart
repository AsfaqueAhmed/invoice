import 'package:get/get.dart';
import '../controllers/due_payment_controller.dart';
class DuePaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DuePaymentController>(() => DuePaymentController());
  }
}
