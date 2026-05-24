import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCustomerController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController businessNameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController stateCtrl = TextEditingController();
  final TextEditingController postalCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final RxBool isSaving = false.obs;

  String? validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  @override
  void onClose() {
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    stateCtrl.dispose();
    postalCtrl.dispose();
    cityCtrl.dispose();
    super.onClose();
  }

  void onSave() {}
}
