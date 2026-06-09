import '../../domain/models/business.dart';
import '../../domain/repositories/business_repository.dart';
import '../datasources/business_local_datasource.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final BusinessLocalDatasource _datasource;

  BusinessRepositoryImpl(this._datasource);

  @override
  Future<List<Business>> getAll() => _datasource.getAll();

  @override
  Future<void> create(Business business) => _datasource.create(business);

  @override
  Future<void> update(Business business) => _datasource.update(business);

  @override
  Future<void> delete(String id) => _datasource.delete(id);
}
