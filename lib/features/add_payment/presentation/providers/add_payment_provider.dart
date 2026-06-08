import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

const addPaymentMethods = [
  {'label': 'Cash', 'icon': Icons.payments_outlined},
  {'label': 'bKash', 'icon': Icons.account_balance_wallet_outlined},
  {'label': 'Nagad', 'icon': Icons.send_to_mobile_outlined},
  {'label': 'Bank', 'icon': Icons.account_balance_outlined},
  {'label': 'Card', 'icon': Icons.credit_card_outlined},
];

final addPaymentProvider =
    NotifierProvider<AddPaymentNotifier, AddPaymentState>(
  AddPaymentNotifier.new,
);

class AddPaymentState {
  const AddPaymentState({
    this.amount = '0.00',
    this.selectedMethod = 'Cash',
    this.selectedDate = '',
    this.isSaving = false,
  });

  final String amount;
  final String selectedMethod;
  final String selectedDate;
  final bool isSaving;

  AddPaymentState copyWith({
    String? amount,
    String? selectedMethod,
    String? selectedDate,
    bool? isSaving,
  }) {
    return AddPaymentState(
      amount: amount ?? this.amount,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      selectedDate: selectedDate ?? this.selectedDate,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class AddPaymentNotifier extends Notifier<AddPaymentState> {
  @override
  AddPaymentState build() {
    final now = DateTime.now();
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return AddPaymentState(selectedDate: date);
  }

  void pressKey(String key) {
    String cur = state.amount;
    if (cur == '0.00' || cur == '0') {
      cur = key == '.' ? '0.' : key;
    } else {
      if (key == '.' && cur.contains('.')) return;
      if (cur.contains('.') && cur.split('.')[1].length >= 2) return;
      cur += key;
    }
    state = state.copyWith(amount: cur);
  }

  void backspace() {
    if (state.amount.length <= 1) {
      state = state.copyWith(amount: '0.00');
    } else {
      state = state.copyWith(
        amount: state.amount.substring(0, state.amount.length - 1),
      );
    }
  }

  void selectMethod(String method) =>
      state = state.copyWith(selectedMethod: method);

  Future<void> onConfirm() async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(milliseconds: 1500));
    state = state.copyWith(isSaving: false);
    Get.back();
    Get.snackbar('Success', 'Payment recorded successfully',
        snackPosition: SnackPosition.BOTTOM);
  }
}
