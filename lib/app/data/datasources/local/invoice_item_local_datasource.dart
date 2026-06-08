import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_service.dart';
import '../../entities/invoice_item_entity.dart';

class InvoiceItemLocalDatasource {
  final DatabaseService databaseService;

  InvoiceItemLocalDatasource(
    this.databaseService,
  );

  Future<List<InvoiceItemEntity>> getAll() async {
    final Database db = await databaseService.database;

    final result = await db.query('invoice_items');

    return result.map((e) => InvoiceItemEntity.fromJson(e)).toList();
  }

  Future<void> create(
    InvoiceItemEntity item, {
    DatabaseExecutor? executor,
  }) async {
    final DatabaseExecutor db = executor ?? await databaseService.database;

    await db.insert(
      'invoice_items',
      item.toJson(),
    );
  }

  Future<void> update(
    InvoiceItemEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.update(
      'invoice_items',
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
      'invoice_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
