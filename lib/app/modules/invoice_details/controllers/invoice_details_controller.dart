import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../models/invoice_detail_item.dart';

class InvoiceDetailsController extends GetxController {
  final List<InvoiceDetailItem> items = const [
    InvoiceDetailItem(
      description: 'Brand Strategy Workshop',
      note: '2-day intensive session',
      quantity: 1,
      rate: 2500,
    ),
    InvoiceDetailItem(
      description: 'UI/UX Design Kit',
      note: 'Figma components & documentation',
      quantity: 3,
      rate: 450,
    ),
    InvoiceDetailItem(
      description: 'Ongoing Consulting',
      note: 'Monthly retainer',
      quantity: 10,
      rate: 150,
    ),
  ];

  double get subtotal => items.fold(0.0, (total, item) => total + item.amount);

  double get tax => subtotal * 0.08;

  double get total => subtotal + tax;

  double get amountPaid => total;

  double get balanceDue => total - amountPaid;

  void sharePdf() {
    Get.snackbar(
      'Share PDF',
      'PDF sharing flow is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void printInvoice() {
    Get.snackbar(
      'Print',
      'Print flow is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void editInvoice() {
    Get.toNamed(Routes.createInvoice);
  }

  void addPayment() {
    Get.snackbar(
      'Payment',
      'Payment collection flow is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
