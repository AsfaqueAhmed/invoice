import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_service.dart';
import '../../entities/expense_entity.dart';

class ExpenseLocalDatasource {
  final DatabaseService databaseService;

  ExpenseLocalDatasource(
    this.databaseService,
  );

  Future<List<ExpenseEntity>> getAll() async {
    final Database db = await databaseService.database;

    final result = await db.query('expenses');

    return result.map((e) => ExpenseEntity.fromJson(e)).toList();
  }

  Future<void> create(
    ExpenseEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.insert(
      'expenses',
      item.toJson(),
    );
  }

  Future<void> update(
    ExpenseEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.update(
      'expenses',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> delete(
    String id,
  ) async {
    final Database db = await databaseService.database;

    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
