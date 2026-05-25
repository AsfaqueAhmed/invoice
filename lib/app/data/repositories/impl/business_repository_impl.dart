
import '../../entities/business_entity.dart';
import '../../datasources/local/business_local_datasource.dart';
import '../abstract/business_repository.dart';

class BusinessRepositoryImpl
    implements BusinessRepository {

  final BusinessLocalDatasource datasource;

  BusinessRepositoryImpl(
    this.datasource,
  );

  @override
  Future<List<BusinessEntity>> getAll() {
    return datasource.getAll();
  }

  @override
  Future<void> create(
    BusinessEntity item,
  ) {
    return datasource.create(item);
  }

  @override
  Future<void> update(
    BusinessEntity item,
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
