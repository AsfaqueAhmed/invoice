import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_service.dart';
import '../../entities/product_entity.dart';

class ProductLocalDatasource {
  final DatabaseService databaseService;

  ProductLocalDatasource(
    this.databaseService,
  );

  Future<List<ProductEntity>> getAll() async {
    final Database db = await databaseService.database;

    final result = await db.query('products');

    return result.map((e) => ProductEntity.fromJson(e)).toList();
  }

  Future<void> create(
    ProductEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.insert(
      'products',
      item.toJson(),
    );
  }

  Future<void> update(
    ProductEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.update(
      'products',
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
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
