
import '../../entities/customer_entity.dart';
import '../../datasources/local/customer_local_datasource.dart';
import '../abstract/customer_repository.dart';

class CustomerRepositoryImpl
    implements CustomerRepository {

  final CustomerLocalDatasource datasource;

  CustomerRepositoryImpl(
    this.datasource,
  );

  @override
  Future<List<CustomerEntity>> getAll() {
    return datasource.getAll();
  }

  @override
  Future<void> create(
    CustomerEntity item,
  ) {
    return datasource.create(item);
  }

  @override
  Future<void> update(
    CustomerEntity item,
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
