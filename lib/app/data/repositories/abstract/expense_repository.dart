
import '../../entities/expense_entity.dart';

abstract class ExpenseRepository {

  Future<List<ExpenseEntity>> getAll();

  Future<void> create(
    ExpenseEntity item,
  );

  Future<void> update(
    ExpenseEntity item,
  );

  Future<void> delete(
    String id,
  );
}
