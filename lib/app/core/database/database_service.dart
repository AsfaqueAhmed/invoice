
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  static final DatabaseService _instance =
      DatabaseService._internal();

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

    final path = join(dbPath, 'invoice_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {

    await db.execute('''
      CREATE TABLE customers(
        id TEXT PRIMARY KEY,
        name TEXT,
        phone TEXT,
        address TEXT,
        totalDue REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE products(
        id TEXT PRIMARY KEY,
        name TEXT,
        sku TEXT,
        category TEXT,
        purchasePrice REAL,
        sellingPrice REAL,
        stock INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE invoices(
        id TEXT PRIMARY KEY,
        customerId TEXT,
        invoiceNo TEXT,
        subtotal REAL,
        discount REAL,
        tax REAL,
        total REAL,
        paid REAL,
        due REAL,
        status TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE invoice_items(
        id TEXT PRIMARY KEY,
        invoiceId TEXT,
        productId TEXT,
        name TEXT,
        qty INTEGER,
        price REAL,
        total REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE payments(
        id TEXT PRIMARY KEY,
        invoiceId TEXT,
        amount REAL,
        method TEXT,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses(
        id TEXT PRIMARY KEY,
        category TEXT,
        amount REAL,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE businesses(
        id TEXT PRIMARY KEY,
        name TEXT,
        phone TEXT,
        address TEXT,
        logo TEXT,
        currency TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        darkMode INTEGER,
        language TEXT,
        invoicePrefix TEXT,
        enableTax INTEGER
      )
    ''');
  }
}
