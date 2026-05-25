
import '../../entities/payment_entity.dart';

abstract class PaymentRepository {

  Future<List<PaymentEntity>> getAll();

  Future<void> create(
    PaymentEntity item,
  );

  Future<void> update(
    PaymentEntity item,
  );

  Future<void> delete(
    String id,
  );
}
