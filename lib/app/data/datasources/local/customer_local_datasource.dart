import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_service.dart';
import '../../entities/customer_entity.dart';

class CustomerLocalDatasource {
  final DatabaseService databaseService;

  CustomerLocalDatasource(this.databaseService);

  Future<List<CustomerEntity>> getAll() async {
    final Database db = await databaseService.database;

    final result = await db.query('customers');

    return result.map((e) => CustomerEntity.fromJson(e)).toList();
  }

  Future<void> create(
    CustomerEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.insert(
      'customers',
      item.toJson(),
    );
  }

  Future<void> update(
    CustomerEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.update(
      'customers',
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
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
