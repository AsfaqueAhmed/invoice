import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_getx_app/core/utils/image_utils.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/customer.dart';
import '../../domain/repositories/customer_repository.dart';

class AddCustomerController extends GetxController {
  final CustomerRepository _repository;

  AddCustomerController(this._repository);

  final formKey = GlobalKey<FormState>();
  final RxBool isSaving = false.obs;

  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final postalCtrl = TextEditingController();

  final Rx<File?> customerAvatar = Rx<File?>(null);

  Future<void> onSave() async {
    if (!formKey.currentState!.validate()) return;
    isSaving(true);
    try {
      final address = [
        addressCtrl.text.trim(),
        cityCtrl.text.trim(),
        stateCtrl.text.trim(),
        postalCtrl.text.trim(),
      ].where((s) => s.isNotEmpty).join(', ');

      final customer = Customer(
        id: const Uuid().v4(),
        name: fullNameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        address: address,
        totalDue: 0,
      );
      await _repository.create(customer);
      Get.back(result: true);
      Get.snackbar('Success', 'Customer saved!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    } catch (_) {
      Get.snackbar('Error', 'Could not save customer. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving(false);
    }
  }

  Future<void> onPickAvatar() async {
    final picked = await ImageUtils.pickImageFromGallery();
    if (picked != null) customerAvatar(File(picked.path));
  }

  @override
  void onClose() {
    fullNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    postalCtrl.dispose();
    super.onClose();
  }
}
