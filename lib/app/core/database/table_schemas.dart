part of 'database_service.dart';

const tBusiness = '''
      CREATE TABLE businesses(
        id TEXT PRIMARY KEY,
        name TEXT,
        phone TEXT,
        address TEXT,
        logo TEXT,
        currency TEXT
      )
    ''';

const tSettings = '''
      CREATE TABLE settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        darkMode INTEGER,
        language TEXT,
        invoicePrefix TEXT,
        enableTax INTEGER
      )
    ''';

const tCustomer = '''
      CREATE TABLE customers(
        id TEXT PRIMARY KEY,
        name TEXT,
        phone TEXT,
        address TEXT,
        totalDue REAL
      )
    ''';

const tProduct = '''
      CREATE TABLE products(
        id TEXT PRIMARY KEY,
        name TEXT,
        sku TEXT,
        category TEXT,
        purchasePrice REAL,
        sellingPrice REAL,
        stock INTEGER,
        description TEXT,
        image TEXT,
        isProductActive INTEGER NOT NULL DEFAULT 1
      )
    ''';

const tInvoice = '''
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
    ''';

const tInvoiceItem = '''
      CREATE TABLE invoice_items(
        id TEXT PRIMARY KEY,
        invoiceId TEXT,
        productId TEXT,
        name TEXT,
        qty INTEGER,
        price REAL,
        total REAL
      )
    ''';

const tPayment = '''
      CREATE TABLE payments(
        id TEXT PRIMARY KEY,
        invoiceId TEXT,
        amount REAL,
        method TEXT,
        note TEXT
      )
    ''';

const tExpense = '''
      CREATE TABLE expenses(
        id TEXT PRIMARY KEY,
        category TEXT,
        amount REAL,
        note TEXT
      )
    ''';
