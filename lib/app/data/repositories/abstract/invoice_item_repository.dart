
import '../../entities/invoice_item_entity.dart';

abstract class InvoiceItemRepository {

  Future<List<InvoiceItemEntity>> getAll();

  Future<void> create(
    InvoiceItemEntity item,
  );

  Future<void> update(
    InvoiceItemEntity item,
  );

  Future<void> delete(
    String id,
  );
}
