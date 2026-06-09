import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPaymentController extends GetxController {
  final noteController = TextEditingController();
  final RxString amount = '0.00'.obs;
  final RxString selectedMethod = 'Cash'.obs;
  final RxString selectedDate = ''.obs;
  final RxBool isSaving = false.obs;
  final methods = [
    {'label': 'Cash', 'icon': Icons.payments_outlined},
    {'label': 'bKash', 'icon': Icons.account_balance_wallet_outlined},
    {'label': 'Nagad', 'icon': Icons.send_to_mobile_outlined},
    {'label': 'Bank', 'icon': Icons.account_balance_outlined},
    {'label': 'Card', 'icon': Icons.credit_card_outlined},
  ];

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    selectedDate(
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}');
  }

  void pressKey(String key) {
    String cur = amount.value;
    if (cur == '0.00' || cur == '0') {
      cur = key == '.' ? '0.' : key;
    } else {
      if (key == '.' && cur.contains('.')) return;
      if (cur.contains('.') && cur.split('.')[1].length >= 2) return;
      cur += key;
    }
    amount(cur);
  }

  void backspace() {
    if (amount.value.length <= 1) {
      amount('0.00');
    } else {
      amount(amount.value.substring(0, amount.value.length - 1));
    }
  }

  void selectMethod(String m) => selectedMethod(m);

  Future<void> onConfirm() async {
    isSaving(true);
    await Future.delayed(const Duration(milliseconds: 1500));
    isSaving(false);
    Get.back();
    Get.snackbar('Success', 'Payment recorded successfully',
        snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
