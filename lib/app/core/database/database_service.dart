import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'table_schemas.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, 'invoice_app_v4.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    await db.execute(tBusiness);

    await db.execute(tSettings);

    await db.execute(tCustomer);

    await db.execute(tProduct);

    await db.execute(tInvoice);

    await db.execute(tInvoiceItem);

    await db.execute(tPayment);

    await db.execute(tExpense);
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    debugPrint('onUpgrade called: $oldVersion -> $newVersion');
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE products ADD COLUMN image TEXT',
      );
    }
  }
}
