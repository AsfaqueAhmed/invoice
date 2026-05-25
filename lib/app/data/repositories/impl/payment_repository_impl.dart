
import '../../entities/payment_entity.dart';
import '../../datasources/local/payment_local_datasource.dart';
import '../abstract/payment_repository.dart';

class PaymentRepositoryImpl
    implements PaymentRepository {

  final PaymentLocalDatasource datasource;

  PaymentRepositoryImpl(
    this.datasource,
  );

  @override
  Future<List<PaymentEntity>> getAll() {
    return datasource.getAll();
  }

  @override
  Future<void> create(
    PaymentEntity item,
  ) {
    return datasource.create(item);
  }

  @override
  Future<void> update(
    PaymentEntity item,
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
