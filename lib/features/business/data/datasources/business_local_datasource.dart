import 'package:flutter_getx_app/core/database/database_service.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/models/business.dart';
import '../entities/business_entity.dart';

class BusinessLocalDatasource {
  final DatabaseService _db;

  BusinessLocalDatasource(this._db);

  Future<List<Business>> getAll() async {
    final Database db = await _db.database;
    final rows = await db.query('businesses');
    return rows.map((r) => BusinessEntity.fromJson(r).toDomain()).toList();
  }

  Future<void> create(Business business) async {
    final Database db = await _db.database;
    await db.insert('businesses', BusinessEntity.fromDomain(business).toJson());
  }

  Future<void> update(Business business) async {
    final Database db = await _db.database;
    await db.update(
      'businesses',
      BusinessEntity.fromDomain(business).toJson(),
      where: 'id = ?',
      whereArgs: [business.id],
    );
  }

  Future<void> delete(String id) async {
    final Database db = await _db.database;
    await db.delete('businesses', where: 'id = ?', whereArgs: [id]);
  }
}
