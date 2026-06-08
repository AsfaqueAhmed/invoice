import 'package:flutter_getx_app/app/core/extensions/num_extensions.dart';
import 'package:flutter_getx_app/app/core/providers/shared_repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/entities/invoice_summary.dart';

/// Status filter chips shown on the invoice list ('All', 'Paid', ...).
const invoiceStatusFilters = ['All', 'Paid', 'Pending', 'Overdue', 'Partial'];

final invoiceSearchQueryProvider = StateProvider<String>((ref) => '');

final invoiceStatusFilterProvider =
    StateProvider<String>((ref) => invoiceStatusFilters.first);

/// Loads invoices joined with their customer's name. Exposed as
/// `AsyncValue<List<InvoiceSummary>>` so the screen gets loading/error/data
/// states for free.
final invoiceListProvider =
    AsyncNotifierProvider<InvoiceListNotifier, List<InvoiceSummary>>(
  InvoiceListNotifier.new,
);

class InvoiceListNotifier extends AsyncNotifier<List<InvoiceSummary>> {
  @override
  Future<List<InvoiceSummary>> build() => _fetchSummaries();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchSummaries);
  }

  Future<List<InvoiceSummary>> _fetchSummaries() async {
    final invoiceRepository = ref.watch(invoiceRepositoryProvider);
    final customerRepository = ref.watch(customerRepositoryProvider);

    final invoices = await invoiceRepository.getAll();
    final customers = await customerRepository.getAll();
    final customerNameById = {for (final c in customers) c.id: c.name};

    return invoices
        .map((invoice) => InvoiceSummary(
              id: invoice.id,
              invoiceNo: invoice.invoiceNo,
              customerName: customerNameById[invoice.customerId] ?? 'Unknown',
              total: invoice.total,
              paid: invoice.paid,
              due: invoice.due,
              status: invoice.status,
            ))
        .toList();
  }
}

/// Invoices narrowed down by the active status filter and search query.
final filteredInvoicesProvider = Provider<List<InvoiceSummary>>((ref) {
  final invoices = ref.watch(invoiceListProvider).valueOrNull ?? [];
  final filter = ref.watch(invoiceStatusFilterProvider).toLowerCase();
  final query = ref.watch(invoiceSearchQueryProvider).toLowerCase().trim();

  return invoices.where((invoice) {
    final matchesFilter = filter == 'all' || invoice.status == filter;
    final matchesQuery = query.isEmpty ||
        invoice.invoiceNo.toLowerCase().contains(query) ||
        invoice.customerName.toLowerCase().contains(query);
    return matchesFilter && matchesQuery;
  }).toList();
});

final totalReceivableProvider = Provider<String>((ref) {
  final invoices = ref.watch(invoiceListProvider).valueOrNull ?? [];
  return invoices.fold<double>(0, (sum, i) => sum + i.due).asCurrency;
});

final collectedToDateProvider = Provider<String>((ref) {
  final invoices = ref.watch(invoiceListProvider).valueOrNull ?? [];
  return invoices.fold<double>(0, (sum, i) => sum + i.paid).asCurrency;
});
