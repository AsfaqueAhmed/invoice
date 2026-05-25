
import '../../entities/business_entity.dart';

abstract class BusinessRepository {

  Future<List<BusinessEntity>> getAll();

  Future<void> create(
    BusinessEntity item,
  );

  Future<void> update(
    BusinessEntity item,
  );

  Future<void> delete(
    String id,
  );
}
