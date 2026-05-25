
import '../../entities/expense_entity.dart';
import '../../datasources/local/expense_local_datasource.dart';
import '../abstract/expense_repository.dart';

class ExpenseRepositoryImpl
    implements ExpenseRepository {

  final ExpenseLocalDatasource datasource;

  ExpenseRepositoryImpl(
    this.datasource,
  );

  @override
  Future<List<ExpenseEntity>> getAll() {
    return datasource.getAll();
  }

  @override
  Future<void> create(
    ExpenseEntity item,
  ) {
    return datasource.create(item);
  }

  @override
  Future<void> update(
    ExpenseEntity item,
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
