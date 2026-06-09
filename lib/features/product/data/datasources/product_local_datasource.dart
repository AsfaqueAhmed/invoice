import 'package:flutter_getx_app/core/database/database_service.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/models/product.dart';
import '../entities/product_entity.dart';

class ProductLocalDatasource {
  final DatabaseService _db;

  ProductLocalDatasource(this._db);

  Future<List<Product>> getAll() async {
    final Database db = await _db.database;
    final rows = await db.query('products');
    return rows.map((r) => ProductEntity.fromJson(r).toDomain()).toList();
  }

  Future<void> create(Product product) async {
    final Database db = await _db.database;
    await db.insert('products', ProductEntity.fromDomain(product).toJson());
  }

  Future<void> update(Product product) async {
    final Database db = await _db.database;
    await db.update(
      'products',
      ProductEntity.fromDomain(product).toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> delete(String id) async {
    final Database db = await _db.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
