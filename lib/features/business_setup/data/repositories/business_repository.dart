import '../../domain/entities/business_entity.dart';
import '../datasources/business_local_datasource.dart';

class BusinessRepository {
  final BusinessLocalDatasource _datasource;

  BusinessRepository(this._datasource);

  Future<List<BusinessEntity>> getAll() => _datasource.getAll();

  Future<void> create(BusinessEntity item) => _datasource.create(item);

  Future<void> update(BusinessEntity item) => _datasource.update(item);

  Future<void> delete(String id) => _datasource.delete(id);
}
