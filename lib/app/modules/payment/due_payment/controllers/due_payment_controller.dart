import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class DuePaymentController extends GetxController {
  final RxString selectedFilter = 'Today'.obs;
  final filters = ['Today', 'Overdue', 'High Due', 'Recent'];
  final totalDue = r'$24,590.00';
  final payments = <Map<String, dynamic>>[
    {
      'name': 'Evergreen Media Group',
      'status': 'overdue',
      'badge': 'Overdue by 3 days',
      'amount': r'$4,250.00',
      'isOverdue': true
    },
    {
      'name': 'Design Theory Lab',
      'status': 'due',
      'badge': 'Due in 2 days',
      'amount': r'$1,890.00',
      'isOverdue': false
    },
    {
      'name': 'Soma Marketings',
      'status': 'due',
      'badge': 'Due in 5 days',
      'amount': r'$12,450.00',
      'isOverdue': false
    },
    {
      'name': 'Lighthouse Devs',
      'status': 'overdue',
      'badge': 'Overdue by 12 days',
      'amount': r'$6,000.00',
      'isOverdue': true
    },
  ].obs;

  void onFilter(String f) => selectedFilter(f);

  void onCollect(Map<String, dynamic> p) =>
      Get.toNamed(Routes.ADD_PAYMENT, arguments: p);

  void onCall(Map<String, dynamic> p) {}

  void onRemind(Map<String, dynamic> p) {}
}
