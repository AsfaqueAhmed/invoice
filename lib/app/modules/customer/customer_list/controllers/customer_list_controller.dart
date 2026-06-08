import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/extensions/num_extensions.dart';
import '../../../../data/entities/customer_entity.dart';
import '../../../../data/repositories/customer_repository.dart';
import '../../../../routes/app_pages.dart';

class CustomerListController extends GetxController {
  CustomerListController(this._repository);

  final CustomerRepository _repository;

  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;

  final RxList<CustomerEntity> _allCustomers = <CustomerEntity>[].obs;

  // Computed stats
  int get totalCustomers => _allCustomers.length;

  String get totalOverdue {
    final total = _allCustomers.fold<double>(
      0,
      (sum, c) => sum + c.totalDue,
    );
    return total.asCurrency;
  }

  List<CustomerEntity> get filtered {
    final q = searchQuery.value.toLowerCase().trim();
    if (q.isEmpty) return _allCustomers;
    return _allCustomers
        .where((c) => c.name.toLowerCase().contains(q) || c.phone.contains(q))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    isLoading(true);
    try {
      final list = await _repository.getAll();
      _allCustomers.value = list;
    } catch (_) {
      _allCustomers.value = [];
    } finally {
      isLoading(false);
    }
  }

  Future<void> refresh() => _loadCustomers();

  void onSearch(String v) => searchQuery(v);

  void onCustomerTap(CustomerEntity c) =>
      Get.toNamed(Routes.CUSTOMER_DETAILS, arguments: c);

  Future<void> onAddCustomer() async {
    await Get.toNamed(Routes.ADD_CUSTOMER);
    await _loadCustomers();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
