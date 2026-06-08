import 'package:flutter_getx_app/features/invoices/data/providers.dart';
import 'package:flutter_getx_app/features/invoices/domain/entities/invoice_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/entities/customer_entity.dart';

/// Everything the customer details screen needs: the customer profile plus
/// their invoice history and the financial totals derived from it.
class CustomerDetails {
  const CustomerDetails({required this.customer, required this.invoices});

  final CustomerEntity customer;
  final List<InvoiceEntity> invoices;

  double get totalPurchases =>
      invoices.fold(0.0, (sum, inv) => sum + inv.total);

  double get totalPaid => invoices.fold(0.0, (sum, inv) => sum + inv.paid);

  double get totalDue => invoices.fold(0.0, (sum, inv) => sum + inv.due);
}

/// Loads a single customer by id, joined with their invoice history.
final customerDetailsProvider =
    FutureProvider.family<CustomerDetails, String>((ref, customerId) async {
  final customerRepository = ref.watch(customerRepositoryProvider);
  final invoiceRepository = ref.watch(invoiceRepositoryProvider);

  final customers = await customerRepository.getAll();
  final customer = customers.firstWhere((c) => c.id == customerId);

  final invoices = await invoiceRepository.getAll();
  final customerInvoices =
      invoices.where((inv) => inv.customerId == customerId).toList();

  return CustomerDetails(customer: customer, invoices: customerInvoices);
});
