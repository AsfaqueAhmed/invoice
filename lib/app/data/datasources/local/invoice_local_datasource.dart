import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_service.dart';
import '../../entities/invoice_entity.dart';

class InvoiceLocalDatasource {
  final DatabaseService databaseService;

  InvoiceLocalDatasource(
    this.databaseService,
  );

  Future<List<InvoiceEntity>> getAll() async {
    final Database db = await databaseService.database;

    final result = await db.query('invoices');

    return result.map((e) => InvoiceEntity.fromJson(e)).toList();
  }

  Future<void> create(
    InvoiceEntity item, {
    DatabaseExecutor? executor,
  }) async {
    final DatabaseExecutor db = executor ?? await databaseService.database;

    await db.insert(
      'invoices',
      item.toJson(),
    );
  }

  Future<void> update(
    InvoiceEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.update(
      'invoices',
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
      'invoices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
