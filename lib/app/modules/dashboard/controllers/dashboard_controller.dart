import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/data/entities/business_entity.dart';
import 'package:get/get.dart';
import '../../../core/extensions/num_extensions.dart';
import '../../../data/entities/invoice_entity.dart';
import '../../../data/entities/customer_entity.dart';
import '../../../data/repositories/business_repository.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../../data/repositories/invoice_repository.dart';
import '../../../routes/app_pages.dart';

class DashboardController extends GetxController {
  DashboardController(
    this._invoiceRepository,
    this._customerRepository,
    this._businessRepository,
  );

  final InvoiceRepository _invoiceRepository;
  final CustomerRepository _customerRepository;
  final BusinessRepository _businessRepository;

  // ─── Observables ───────────────────────────────────────────────
  final RxBool isLoading = true.obs;

  final RxString todaySales = r'$0.00'.obs;
  final RxString dueAmount = r'$0.00'.obs;
  final RxString collected = r'$0.00'.obs;
  final RxInt totalInvoices = 0.obs;

  final RxList<Map<String, String>> recentInvoices =
      <Map<String, String>>[].obs;

  // ─── Cache ─────────────────────────────────────────────────────
  List<InvoiceEntity> _invoices = [];
  List<CustomerEntity> _customers = [];
  RxList<BusinessEntity> businesses = <BusinessEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  @override
  onReady() async {
    businesses.value = await _businessRepository.getAll();
    super.onReady();
  }

  Future<void> _loadData() async {
    isLoading(true);
    try {
      _invoices = await _invoiceRepository.getAll();
      _customers = await _customerRepository.getAll();
      _buildSummary();
      _buildRecentInvoices();
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
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

    todaySales.value = todaySalesVal.asCurrency;
    dueAmount.value = dueVal.asCurrency;
    collected.value = collectedVal.asCurrency;
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
        'amount': inv.total.asCurrency,
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
  void onNewInvoice() => Get.toNamed(Routes.createInvoice);

  void onNewCustomer() => Get.toNamed(Routes.ADD_CUSTOMER);

  void onAddProduct() => Get.toNamed(Routes.ADD_PRODUCT);

  void onCollectPayment() => Get.toNamed(Routes.ADD_PAYMENT);

  void onSeeAllInvoices() => Get.toNamed(Routes.invoices);

  void onInvoiceTap(Map<String, String> inv) =>
      Get.toNamed(Routes.invoiceDetails, arguments: inv);

  Future<void> refresh() => _loadData();
}
