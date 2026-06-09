import 'package:flutter/material.dart';
import 'package:flutter_getx_app/core/utils/currency_formatter.dart';
import 'package:flutter_getx_app/features/business/domain/models/business.dart';
import 'package:flutter_getx_app/features/business/domain/repositories/business_repository.dart';
import 'package:flutter_getx_app/features/customer/domain/models/customer.dart';
import 'package:flutter_getx_app/features/customer/domain/repositories/customer_repository.dart';
import 'package:flutter_getx_app/features/invoice/domain/models/invoice.dart';
import 'package:flutter_getx_app/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final InvoiceRepository _invoiceRepository;
  final CustomerRepository _customerRepository;
  final BusinessRepository _businessRepository;

  DashboardController(
    this._invoiceRepository,
    this._customerRepository,
    this._businessRepository,
  );

  // ─── Observables ───────────────────────────────────────────────
  final RxBool isLoading = true.obs;

  final RxString todaySales = r'$0.00'.obs;
  final RxString dueAmount = r'$0.00'.obs;
  final RxString collected = r'$0.00'.obs;
  final RxInt totalInvoices = 0.obs;

  final RxList<Map<String, String>> recentInvoices =
      <Map<String, String>>[].obs;

  // ─── Cache ─────────────────────────────────────────────────────
  List<Invoice> _invoices = [];
  List<Customer> _customers = [];
  RxList<Business> businesses = <Business>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  @override
  onReady() async {
    businesses.value = await _businessRepository.getAll();
    debugPrint('businesses: ${businesses.length}');
    super.onReady();
  }

  Future<void> _loadData() async {
    isLoading(true);
    try {
      _invoices = await _invoiceRepository.getAll();
      _customers = await _customerRepository.getAll();
      _buildSummary();
      _buildRecentInvoices();
    } catch (_) {
      // graceful degradation — keep zeros
    } finally {
      isLoading(false);
    }
  }

  void _buildSummary() {
    double todaySalesVal = 0;
    double dueVal = 0;
    double collectedVal = 0;

    for (final inv in _invoices) {
      collectedVal += inv.paid;
      dueVal += inv.due;
      // For demo: treat all invoices as today's sales
      todaySalesVal += inv.total;
    }

    todaySales.value = CurrencyFormatter.format(todaySalesVal);
    dueAmount.value = CurrencyFormatter.format(dueVal);
    collected.value = CurrencyFormatter.format(collectedVal);
    totalInvoices.value = _invoices.length;
  }

  void _buildRecentInvoices() {
    final customerMap = {for (final c in _customers) c.id: c};
    final sorted = [..._invoices]
      ..sort((a, b) => a.invoiceNo.compareTo(b.invoiceNo));
    final recent = sorted.take(5).toList();

    recentInvoices.value = recent.map((inv) {
      final customer = customerMap[inv.customerId];
      return {
        'number': '#${inv.invoiceNo}',
        'client': customer?.name ?? 'Unknown',
        'amount': CurrencyFormatter.format(inv.total),
        'status': inv.status,
      };
    }).toList();

    // Fallback placeholder if DB is empty
    if (recentInvoices.isEmpty) {
      recentInvoices.value = [
        {
          'number': '#INV-001',
          'client': 'Acme Corp Ltd.',
          'amount': r'$1,240.00',
          'status': 'paid',
        },
        {
          'number': '#INV-002',
          'client': 'Global Tech Inc.',
          'amount': r'$450.00',
          'status': 'pending',
        },
        {
          'number': '#INV-003',
          'client': 'Sarah Jenkins',
          'amount': r'$3,100.00',
          'status': 'overdue',
        },
      ];
    }
  }

  // ─── Navigation ────────────────────────────────────────────────
  void onNewInvoice() => Get.toNamed('/create-invoice');

  void onNewCustomer() => Get.toNamed('/add-customer');

  void onAddProduct() => Get.toNamed('/add-product');

  void onCollectPayment() => Get.toNamed('/add-payment');

  void onSeeAllInvoices() => Get.toNamed('/invoices');

  void onInvoiceTap(Map<String, String> inv) =>
      Get.toNamed('/invoice-details', arguments: inv);

  Future<void> refresh() => _loadData();
}
