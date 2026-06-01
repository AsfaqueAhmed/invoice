import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_service.dart';
import '../../entities/business_entity.dart';

class BusinessLocalDatasource {
  final DatabaseService databaseService = DatabaseService();

  BusinessLocalDatasource();

  Future<List<BusinessEntity>> getAll() async {
    final Database db = await databaseService.database;

    final result = await db.query('businesses');

    return result.map((e) => BusinessEntity.fromJson(e)).toList();
  }

  Future<void> create(
    BusinessEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.insert(
      'businesses',
      item.toJson(),
    );
  }

  Future<void> update(
    BusinessEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.update(
      'businesses',
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
      'businesses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
