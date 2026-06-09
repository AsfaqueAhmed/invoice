import '../../domain/models/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_local_datasource.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerLocalDatasource _datasource;

  CustomerRepositoryImpl(this._datasource);

  @override
  Future<List<Customer>> getAll() => _datasource.getAll();

  @override
  Future<void> create(Customer customer) => _datasource.create(customer);

  @override
  Future<void> update(Customer customer) => _datasource.update(customer);

  @override
  Future<void> delete(String id) => _datasource.delete(id);
}
