import '../datasources/local/customer_local_datasource.dart';
import '../entities/customer_entity.dart';

class CustomerRepository {
  final CustomerLocalDatasource _datasource;

  CustomerRepository(this._datasource);

  Future<List<CustomerEntity>> getAll() => _datasource.getAll();

  Future<void> create(CustomerEntity item) => _datasource.create(item);

  Future<void> update(CustomerEntity item) => _datasource.update(item);

  Future<void> delete(String id) => _datasource.delete(id);
}
