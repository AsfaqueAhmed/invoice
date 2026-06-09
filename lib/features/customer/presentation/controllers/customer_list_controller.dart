import 'package:flutter/material.dart';
import 'package:flutter_getx_app/core/utils/currency_formatter.dart';
import 'package:get/get.dart';

import '../../domain/models/customer.dart';
import '../../domain/repositories/customer_repository.dart';

class CustomerListController extends GetxController {
  final CustomerRepository _repository;

  CustomerListController(this._repository);

  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxList<Customer> _allCustomers = <Customer>[].obs;

  int get totalCustomers => _allCustomers.length;

  String get totalOverdue {
    final total = _allCustomers.fold<double>(0, (sum, c) => sum + c.totalDue);
    return CurrencyFormatter.format(total);
  }

  List<Customer> get filtered {
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
      _allCustomers.value = await _repository.getAll();
    } catch (_) {
      _allCustomers.value = [];
    } finally {
      isLoading(false);
    }
  }

  @override
  Future<void> refresh() => _loadCustomers();

  void onSearch(String v) => searchQuery(v);

  void onCustomerTap(Customer c) =>
      Get.toNamed('/customer-details', arguments: c);

  Future<void> onAddCustomer() async {
    await Get.toNamed('/add-customer');
    await _loadCustomers();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
