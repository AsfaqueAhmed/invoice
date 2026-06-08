import 'package:flutter_getx_app/app/core/extensions/num_extensions.dart';
import 'package:flutter_getx_app/features/customer/data/providers.dart';
import 'package:flutter_getx_app/features/customer/domain/entities/customer_entity.dart';
import 'package:flutter_getx_app/features/invoices/data/providers.dart';
import 'package:flutter_getx_app/features/invoices/domain/entities/invoice_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Aggregated figures shown on the dashboard's summary cards and recent
/// invoices list, derived from every saved invoice/customer.
class DashboardSummary {
  const DashboardSummary({
    required this.todaySales,
    required this.dueAmount,
    required this.collected,
    required this.totalInvoices,
    required this.recentInvoices,
  });

  final String todaySales;
  final String dueAmount;
  final String collected;
  final int totalInvoices;
  final List<Map<String, String>> recentInvoices;
}

final dashboardSummaryProvider =
    AsyncNotifierProvider<DashboardSummaryNotifier, DashboardSummary>(
  DashboardSummaryNotifier.new,
);

class DashboardSummaryNotifier extends AsyncNotifier<DashboardSummary> {
  @override
  Future<DashboardSummary> build() => _load();

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<DashboardSummary> _load() async {
    final invoices = await ref.read(invoiceRepositoryProvider).getAll();
    final customers = await ref.read(customerRepositoryProvider).getAll();

    return DashboardSummary(
      todaySales: _sumOf(invoices, (inv) => inv.total).asCurrency,
      dueAmount: _sumOf(invoices, (inv) => inv.due).asCurrency,
      collected: _sumOf(invoices, (inv) => inv.paid).asCurrency,
      totalInvoices: invoices.length,
      recentInvoices: _buildRecentInvoices(invoices, customers),
    );
  }

  double _sumOf(
    List<InvoiceEntity> invoices,
    double Function(InvoiceEntity) selector,
  ) {
    return invoices.fold<double>(0, (sum, inv) => sum + selector(inv));
  }

  List<Map<String, String>> _buildRecentInvoices(
    List<InvoiceEntity> invoices,
    List<CustomerEntity> customers,
  ) {
    final customerMap = {for (final c in customers) c.id: c};
    final sorted = [...invoices]
      ..sort((a, b) => a.invoiceNo.compareTo(b.invoiceNo));

    final recent = sorted.take(5).map((inv) {
      final customer = customerMap[inv.customerId];
      return {
        'number': '#${inv.invoiceNo}',
        'client': customer?.name ?? 'Unknown',
        'amount': inv.total.asCurrency,
        'status': inv.status,
      };
    }).toList();

    if (recent.isNotEmpty) return recent;

    // Fallback placeholder if DB is empty
    return [
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
