
import '../../entities/customer_entity.dart';

abstract class CustomerRepository {

  Future<List<CustomerEntity>> getAll();

  Future<void> create(
    CustomerEntity item,
  );

  Future<void> update(
    CustomerEntity item,
  );

  Future<void> delete(
    String id,
  );
}
