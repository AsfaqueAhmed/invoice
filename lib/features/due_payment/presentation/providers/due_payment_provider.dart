import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

const duePaymentFilters = ['All', 'Overdue', 'Pending', 'Today'];

const _duePayments = <Map<String, Object>>[
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
];

final selectedDuePaymentFilterProvider = StateProvider<String>((ref) => 'All');

/// Demo due-payment list — there's no backing repository yet, so this is a
/// fixed dataset mirroring the original screen's placeholder data.
final duePaymentsProvider = Provider<List<Map<String, Object>>>(
  (ref) => _duePayments,
);

final totalDueProvider = Provider<String>((ref) {
  final total = ref.watch(duePaymentsProvider).fold<double>(0, (sum, p) {
    final raw = (p['amount'] as String).replaceAll(RegExp(r'[^\d.]'), '');
    return sum + (double.tryParse(raw) ?? 0);
  });
  return '\$${total.toStringAsFixed(2)}';
});

void onCollectDuePayment(Map<String, Object> payment) =>
    Get.toNamed(Routes.ADD_PAYMENT);

void onCallDuePayment(Map<String, Object> payment) {}

void onRemindDuePayment(Map<String, Object> payment) {
  Get.snackbar(
    'Reminder Sent',
    'Payment reminder sent to ${payment['name']}',
    snackPosition: SnackPosition.BOTTOM,
  );
}
