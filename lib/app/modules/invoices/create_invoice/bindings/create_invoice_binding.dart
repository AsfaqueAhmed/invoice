import 'package:get/get.dart';
import '../../../../data/repositories/customer_repository.dart';
import '../../../../data/repositories/invoice_repository.dart';
import '../../../../data/repositories/product_repository.dart';
import '../controllers/create_invoice_controller.dart';
class CreateInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateInvoiceController>(
      () => CreateInvoiceController(
        Get.find<CustomerRepository>(),
        Get.find<ProductRepository>(),
        Get.find<InvoiceRepository>(),
      ),
    );
  }
}
