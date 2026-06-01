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

    final path = join(dbPath, 'invoice_app.db');

    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion <= 4) {
      final columns = await db.rawQuery("PRAGMA table_info(customers)");

      final hasEmail = columns.any((col) => col['name'] == 'email');

      if (!hasEmail) {
        await db.execute('ALTER TABLE customers ADD COLUMN email TEXT');
      }
    }
    if (oldVersion <= 5) {
      final columns = await db.rawQuery("PRAGMA table_info(customers)");

      final hasAvatar = columns.any((col) => col['name'] == 'avatar');

      if (!hasAvatar) {
        await db.execute('ALTER TABLE customers ADD COLUMN avatar TEXT');
      }
    }
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
}
