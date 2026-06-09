import 'package:flutter_getx_app/core/database/database_service.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/models/invoice.dart';
import '../entities/invoice_entity.dart';

class InvoiceLocalDatasource {
  final DatabaseService _db;

  InvoiceLocalDatasource(this._db);

  Future<List<Invoice>> getAll() async {
    final Database db = await _db.database;
    final rows = await db.query('invoices');
    return rows.map((r) => InvoiceEntity.fromJson(r).toDomain()).toList();
  }

  Future<void> create(Invoice invoice) async {
    final Database db = await _db.database;
    await db.insert('invoices', InvoiceEntity.fromDomain(invoice).toJson());
  }

  Future<void> update(Invoice invoice) async {
    final Database db = await _db.database;
    await db.update(
      'invoices',
      InvoiceEntity.fromDomain(invoice).toJson(),
      where: 'id = ?',
      whereArgs: [invoice.id],
    );
  }

  Future<void> delete(String id) async {
    final Database db = await _db.database;
    await db.delete('invoices', where: 'id = ?', whereArgs: [id]);
  }
}
