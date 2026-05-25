
import '../../entities/invoice_entity.dart';
import '../../datasources/local/invoice_local_datasource.dart';
import '../abstract/invoice_repository.dart';

class InvoiceRepositoryImpl
    implements InvoiceRepository {

  final InvoiceLocalDatasource datasource;

  InvoiceRepositoryImpl(
    this.datasource,
  );

  @override
  Future<List<InvoiceEntity>> getAll() {
    return datasource.getAll();
  }

  @override
  Future<void> create(
    InvoiceEntity item,
  ) {
    return datasource.create(item);
  }

  @override
  Future<void> update(
    InvoiceEntity item,
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
