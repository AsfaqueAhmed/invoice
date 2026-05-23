import 'package:get/get.dart';

import '../controllers/invoice_list_controller.dart';

class InvoiceListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoiceListController>(() => InvoiceListController());
  }
}
