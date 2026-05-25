import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_service.dart';
import '../../entities/business_entity.dart';

class BusinessLocalDatasource {
  final DatabaseService databaseService;

  BusinessLocalDatasource(
    this.databaseService,
  );

  Future<List<BusinessEntity>> getAll() async {
    final Database db = await databaseService.database;

    final result = await db.query('businesss');

    return result.map((e) => BusinessEntity.fromJson(e)).toList();
  }

  Future<void> create(
    BusinessEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.insert(
      'businesss',
      item.toJson(),
    );
  }

  Future<void> update(
    BusinessEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.update(
      'businesss',
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
      'businesss',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
