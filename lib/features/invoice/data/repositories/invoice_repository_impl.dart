import '../../domain/models/invoice.dart';
import '../../domain/models/invoice_item.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_item_local_datasource.dart';
import '../datasources/invoice_local_datasource.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceLocalDatasource _invoiceDs;
  final InvoiceItemLocalDatasource _itemDs;

  InvoiceRepositoryImpl(this._invoiceDs, this._itemDs);

  @override
  Future<List<Invoice>> getAll() => _invoiceDs.getAll();

  @override
  Future<void> create(Invoice invoice) => _invoiceDs.create(invoice);

  @override
  Future<void> update(Invoice invoice) => _invoiceDs.update(invoice);

  @override
  Future<void> delete(String id) => _invoiceDs.delete(id);

  @override
  Future<List<InvoiceItem>> getItemsByInvoice(String invoiceId) =>
      _itemDs.getByInvoice(invoiceId);

  @override
  Future<void> createItem(InvoiceItem item) => _itemDs.create(item);
}
