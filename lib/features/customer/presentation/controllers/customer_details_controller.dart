import 'package:flutter_getx_app/core/utils/currency_formatter.dart';
import 'package:get/get.dart';

import '../../domain/models/customer.dart';

class CustomerDetailsController extends GetxController {
  final Customer customer = Get.arguments as Customer;

  // Financial summaries — placeholder (wire up real data when needed)
  String get totalPurchases => CurrencyFormatter.format(0);
  String get totalPaid => CurrencyFormatter.format(0);
  String get totalDue => CurrencyFormatter.format(0);

  // Placeholder invoice history
  List<Map<String, dynamic>> get invoices => [
        {
          'number': '#INV-001',
          'date': 'Oct 24, 2023',
          'amount': r'$1,240.00',
          'status': 'paid',
        },
      ];

  void onNewInvoice() => Get.toNamed('/create-invoice');

  void onCollectPayment() => Get.toNamed('/add-payment');

  void onCall() {
    // TODO: implement url_launcher call when dependency is added
  }

  void onInvoiceTap(Map<String, dynamic> inv) =>
      Get.toNamed('/invoice-details', arguments: inv);
}
