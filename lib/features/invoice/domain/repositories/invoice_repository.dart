import '../models/invoice.dart';
import '../models/invoice_item.dart';

abstract class InvoiceRepository {
  Future<List<Invoice>> getAll();
  Future<void> create(Invoice invoice);
  Future<void> update(Invoice invoice);
  Future<void> delete(String id);

  Future<List<InvoiceItem>> getItemsByInvoice(String invoiceId);
  Future<void> createItem(InvoiceItem item);
}
