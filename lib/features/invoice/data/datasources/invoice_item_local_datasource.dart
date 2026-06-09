import 'package:flutter_getx_app/core/database/database_service.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/models/invoice_item.dart';
import '../entities/invoice_item_entity.dart';

class InvoiceItemLocalDatasource {
  final DatabaseService _db;

  InvoiceItemLocalDatasource(this._db);

  Future<List<InvoiceItem>> getByInvoice(String invoiceId) async {
    final Database db = await _db.database;
    final rows = await db.query(
      'invoice_items',
      where: 'invoiceId = ?',
      whereArgs: [invoiceId],
    );
    return rows.map((r) => InvoiceItemEntity.fromJson(r).toDomain()).toList();
  }

  Future<void> create(InvoiceItem item) async {
    final Database db = await _db.database;
    await db.insert(
        'invoice_items', InvoiceItemEntity.fromDomain(item).toJson());
  }

  Future<void> delete(String id) async {
    final Database db = await _db.database;
    await db.delete('invoice_items', where: 'id = ?', whereArgs: [id]);
  }
}
