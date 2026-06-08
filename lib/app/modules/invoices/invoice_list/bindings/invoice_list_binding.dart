import 'package:get/get.dart';
import '../../../../data/repositories/customer_repository.dart';
import '../../../../data/repositories/invoice_repository.dart';
import '../controllers/invoice_list_controller.dart';
class InvoiceListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoiceListController>(
      () => InvoiceListController(Get.find<InvoiceRepository>(), Get.find<CustomerRepository>()),
    );
  }
}
