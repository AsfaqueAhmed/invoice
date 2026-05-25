
import '../../entities/invoice_item_entity.dart';
import '../../datasources/local/invoice_item_local_datasource.dart';
import '../abstract/invoice_item_repository.dart';

class InvoiceItemRepositoryImpl
    implements InvoiceItemRepository {

  final InvoiceItemLocalDatasource datasource;

  InvoiceItemRepositoryImpl(
    this.datasource,
  );

  @override
  Future<List<InvoiceItemEntity>> getAll() {
    return datasource.getAll();
  }

  @override
  Future<void> create(
    InvoiceItemEntity item,
  ) {
    return datasource.create(item);
  }

  @override
  Future<void> update(
    InvoiceItemEntity item,
  ) {
    return datasource.update(item);
  }

  @override
  Future<void> delete(
    String id,
  ) {
    return datasource.delete(id);
  }
}
