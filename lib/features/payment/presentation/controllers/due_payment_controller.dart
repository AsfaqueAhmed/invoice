import 'package:get/get.dart';

class DuePaymentController extends GetxController {
  final RxString selectedFilter = 'All'.obs;
  final filters = ['All', 'Overdue', 'Pending', 'Today'];

  final payments = <Map<String, dynamic>>[
    {
      'name': 'Acme Corp Ltd.',
      'amount': r'$3,200.00',
      'badge': '14 days overdue',
      'isOverdue': true,
    },
    {
      'name': 'Sarah Jenkins',
      'amount': r'$890.00',
      'badge': 'Due today',
      'isOverdue': false,
    },
    {
      'name': 'Global Tech Inc.',
      'amount': r'$1,450.00',
      'badge': '3 days overdue',
      'isOverdue': true,
    },
    {
      'name': 'Bright Solutions',
      'amount': r'$560.00',
      'badge': 'Due in 2 days',
      'isOverdue': false,
    },
  ].obs;

  String get totalDue {
    final total = payments.fold<double>(
      0,
      (s, p) {
        final raw = (p['amount'] as String).replaceAll(RegExp(r'[^\d.]'), '');
        return s + (double.tryParse(raw) ?? 0);
      },
    );
    return '\$${total.toStringAsFixed(2)}';
  }

  void onFilter(String f) => selectedFilter(f);

  void onCollect(Map<String, dynamic> p) => Get.toNamed('/add-payment');

  void onCall(Map<String, dynamic> p) {}

  void onRemind(Map<String, dynamic> p) {
    Get.snackbar(
      'Reminder Sent',
      'Payment reminder sent to ${p['name']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
