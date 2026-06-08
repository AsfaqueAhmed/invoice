import '../../core/database/database_service.dart';
import '../datasources/local/invoice_item_local_datasource.dart';
import '../datasources/local/invoice_local_datasource.dart';
import '../entities/invoice_entity.dart';
import '../entities/invoice_item_entity.dart';

class InvoiceRepository {
  final DatabaseService _databaseService;
  final InvoiceLocalDatasource _invoiceDatasource;
  final InvoiceItemLocalDatasource _itemDatasource;

  InvoiceRepository(
    this._databaseService,
    this._invoiceDatasource,
    this._itemDatasource,
  );

  Future<List<InvoiceEntity>> getAll() => _invoiceDatasource.getAll();

  Future<List<InvoiceItemEntity>> getItems(String invoiceId) async {
    final items = await _itemDatasource.getAll();
    return items.where((item) => item.invoiceId == invoiceId).toList();
  }

  Future<void> update(InvoiceEntity item) => _invoiceDatasource.update(item);

  Future<void> delete(String id) => _invoiceDatasource.delete(id);

  /// Persists an invoice together with its line items in a single
  /// transaction so the two tables never end up out of sync.
  Future<void> createInvoiceWithItems(
    InvoiceEntity invoice,
    List<InvoiceItemEntity> items,
  ) async {
    final db = await _databaseService.database;

    await db.transaction((txn) async {
      await _invoiceDatasource.create(invoice, executor: txn);
      for (final item in items) {
        await _itemDatasource.create(item, executor: txn);
      }
    });
  }
}
