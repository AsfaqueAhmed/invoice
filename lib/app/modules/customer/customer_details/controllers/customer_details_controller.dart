import 'package:flutter_getx_app/app/data/entities/customer_entity.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class CustomerDetailsController extends GetxController {
  final customer = Get.arguments as CustomerEntity;
  final invoices = <Map<String, dynamic>>[
    {
      'number': 'INV-2024-081',
      'date': 'March 12, 2024',
      'amount': r'$3,400.00',
      'status': 'overdue'
    },
    {
      'number': 'INV-2024-074',
      'date': 'Feb 28, 2024',
      'amount': r'$2,850.00',
      'status': 'paid'
    },
    {
      'number': 'INV-2024-062',
      'date': 'Feb 15, 2024',
      'amount': r'$1,200.00',
      'status': 'paid'
    },
  ];
  final totalPurchases = r'$24,450.00';
  final totalPaid = r'$18,200.00';
  final totalDue = r'$6,250.00';

  @override
  void onInit() {
    super.onInit();
  }

  void onCall() {}

  void onNewInvoice() {
    Get.toNamed(Routes.createInvoice);
  }

  void onCollectPayment() {
    Get.toNamed(Routes.ADD_PAYMENT);
  }

  void onInvoiceTap(Map<String, dynamic> inv) {
    Get.toNamed(Routes.invoiceDetails, arguments: inv);
  }
}
