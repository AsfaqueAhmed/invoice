import 'package:get/get.dart';

class InvoiceDetailsController extends GetxController {
  late final Map<String, dynamic> invoice;

  @override
  void onInit() {
    super.onInit();
    invoice = Get.arguments as Map<String, dynamic>? ?? {
      'number': '1024',
      'client': 'Acme Corp',
      'date': 'Oct 24, 2023',
      'amount': r'$5,778.00',
      'status': 'paid',
      'due': r'$0.00',
    };
  }

  void onAddPayment() => Get.toNamed('/add-payment');

  void onShare() {}

  void onPrint() {}

  void onEdit() {}
}
