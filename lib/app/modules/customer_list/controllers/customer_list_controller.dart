import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class CustomerListController extends GetxController {
  final searchController = TextEditingController();

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void updateSearch(String value) {}

  void openFilterSheet() {}

  void onAddNewCustomerTap() {
    Get.toNamed(Routes.ADD_CUSTOMER);
  }

  void onCustomerCardTap() {
    Get.toNamed(Routes.CUSTOMER_DETAILS);
  }
}
