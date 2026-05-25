import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_service.dart';
import '../../entities/payment_entity.dart';

class PaymentLocalDatasource {
  final DatabaseService databaseService;

  PaymentLocalDatasource(
    this.databaseService,
  );

  Future<List<PaymentEntity>> getAll() async {
    final Database db = await databaseService.database;

    final result = await db.query('payments');

    return result.map((e) => PaymentEntity.fromJson(e)).toList();
  }

  Future<void> create(
    PaymentEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.insert(
      'payments',
      item.toJson(),
    );
  }

  Future<void> update(
    PaymentEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.update(
      'payments',
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
      'payments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
