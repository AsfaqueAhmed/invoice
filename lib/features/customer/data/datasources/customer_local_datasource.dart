import 'package:flutter_getx_app/core/database/database_service.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/models/customer.dart';
import '../entities/customer_entity.dart';

class CustomerLocalDatasource {
  final DatabaseService _db;

  CustomerLocalDatasource(this._db);

  Future<List<Customer>> getAll() async {
    final Database db = await _db.database;
    final rows = await db.query('customers');
    return rows.map((r) => CustomerEntity.fromJson(r).toDomain()).toList();
  }

  Future<void> create(Customer customer) async {
    final Database db = await _db.database;
    await db.insert('customers', CustomerEntity.fromDomain(customer).toJson());
  }

  Future<void> update(Customer customer) async {
    final Database db = await _db.database;
    await db.update(
      'customers',
      CustomerEntity.fromDomain(customer).toJson(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<void> delete(String id) async {
    final Database db = await _db.database;
    await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }
}
