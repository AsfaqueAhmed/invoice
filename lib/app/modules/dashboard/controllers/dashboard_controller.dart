import 'package:flutter_getx_app/app/data/datasources/local/business_local_datasource.dart';
import 'package:flutter_getx_app/app/data/entities/business_entity.dart';
import 'package:get/get.dart';
import '../../../data/datasources/local/invoice_local_datasource.dart';
import '../../../data/datasources/local/customer_local_datasource.dart';
import '../../../data/entities/invoice_entity.dart';
import '../../../data/entities/customer_entity.dart';
import '../../../core/database/database_service.dart';
import '../../../routes/app_pages.dart';

class DashboardController extends GetxController {
  // ─── Observables ───────────────────────────────────────────────
  final RxBool isLoading = true.obs;

  final RxString todaySales = r'$0.00'.obs;
  final RxString dueAmount = r'$0.00'.obs;
  final RxString collected = r'$0.00'.obs;
  final RxInt totalInvoices = 0.obs;

  final RxList<Map<String, String>> recentInvoices =
      <Map<String, String>>[].obs;

  // ─── Data sources ──────────────────────────────────────────────
  late final InvoiceLocalDatasource _invoiceDs;
  late final CustomerLocalDatasource _customerDs;

  // ─── Cache ─────────────────────────────────────────────────────
  List<InvoiceEntity> _invoices = [];
  List<CustomerEntity> _customers = [];
  RxList<BusinessEntity> businesses = <BusinessEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    final db = DatabaseService();
    _invoiceDs = InvoiceLocalDatasource(db);
    _customerDs = CustomerLocalDatasource(db);
    _loadData();
  }

  @override
  onReady() async {
    businesses.value = await BusinessLocalDatasource().getAll();
    super.onReady();
  }

  Future<void> _loadData() async {
    isLoading(true);
    try {
      _invoices = await _invoiceDs.getAll();
      _customers = await _customerDs.getAll();
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

    // Format currency
    todaySales.value = _fmt(todaySalesVal);
    dueAmount.value = _fmt(dueVal);
    collected.value = _fmt(collectedVal);
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
        'amount': _fmt(inv.total),
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

  String _fmt(double val) {
    if (val >= 1000) {
      return '\$${val.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    }
    return '\$${val.toStringAsFixed(2)}';
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
