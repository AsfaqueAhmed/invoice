import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_service.dart';
import '../../../../data/datasources/local/customer_local_datasource.dart';
import '../../../../data/entities/customer_entity.dart';

class AddCustomerController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final RxBool isSaving = false.obs;

  // Text controllers
  final fullNameCtrl = TextEditingController();
  final businessNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final postalCtrl = TextEditingController();

  late final CustomerLocalDatasource _datasource;

  @override
  void onInit() {
    super.onInit();
    _datasource = CustomerLocalDatasource(DatabaseService());
  }

  String? validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

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

      final entity = CustomerEntity(
        id: const Uuid().v4(),
        name: fullNameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        address: address,
        totalDue: 0,
      );
      await _datasource.create(entity);
      Get.back(result: true);
      Get.snackbar(
        'Success',
        'Customer saved!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not save customer. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving(false);
    }
  }

  @override
  void onClose() {
    fullNameCtrl.dispose();
    businessNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    postalCtrl.dispose();
    super.onClose();
  }
}
