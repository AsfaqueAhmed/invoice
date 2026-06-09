import '../models/business.dart';

abstract class BusinessRepository {
  Future<List<Business>> getAll();
  Future<void> create(Business business);
  Future<void> update(Business business);
  Future<void> delete(String id);
}
