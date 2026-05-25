
import '../../entities/invoice_entity.dart';

abstract class InvoiceRepository {

  Future<List<InvoiceEntity>> getAll();

  Future<void> create(
    InvoiceEntity item,
  );

  Future<void> update(
    InvoiceEntity item,
  );

  Future<void> delete(
    String id,
  );
}
