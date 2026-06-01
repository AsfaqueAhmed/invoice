import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/database/database_service.dart';
import '../../../../data/datasources/local/customer_local_datasource.dart';
import '../../../../data/entities/customer_entity.dart';
import '../../../../routes/app_pages.dart';

class CustomerListController extends GetxController {
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;

  final RxList<CustomerEntity> _allCustomers = <CustomerEntity>[].obs;

  late final CustomerLocalDatasource _datasource;

  // Computed stats
  int get totalCustomers => _allCustomers.length;

  String get totalOverdue {
    final total = _allCustomers.fold<double>(
      0,
      (sum, c) => sum + c.totalDue,
    );
    return _fmt(total);
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
    _datasource = CustomerLocalDatasource();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    isLoading(true);
    try {
      final list = await _datasource.getAll();
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

  String _fmt(double val) {
    if (val >= 1000) {
      return '\$${val.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    }
    return '\$${val.toStringAsFixed(2)}';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
