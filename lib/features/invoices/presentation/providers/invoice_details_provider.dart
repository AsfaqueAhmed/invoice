import 'package:flutter_getx_app/app/core/providers/shared_repository_providers.dart';
import 'package:flutter_getx_app/app/data/entities/customer_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';

/// Everything the invoice details screen needs to render: the invoice
/// itself, its line items, and the customer it was billed to.
class InvoiceDetails {
  const InvoiceDetails({
    required this.invoice,
    required this.customer,
    required this.items,
  });

  final InvoiceEntity invoice;
  final CustomerEntity? customer;
  final List<InvoiceItemEntity> items;
}

/// Loads a single invoice by id, joined with its line items and customer.
final invoiceDetailsProvider =
    FutureProvider.family<InvoiceDetails, String>((ref, invoiceId) async {
  final invoiceRepository = ref.watch(invoiceRepositoryProvider);
  final customerRepository = ref.watch(customerRepositoryProvider);

  final invoices = await invoiceRepository.getAll();
  final invoice = invoices.firstWhere((i) => i.id == invoiceId);
  final items = await invoiceRepository.getItems(invoiceId);

  final customers = await customerRepository.getAll();
  CustomerEntity? customer;
  for (final c in customers) {
    if (c.id == invoice.customerId) {
      customer = c;
      break;
    }
  }

  return InvoiceDetails(invoice: invoice, customer: customer, items: items);
});
