import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_service.dart';
import '../../entities/customer_entity.dart';

class CustomerLocalDatasource {
  final DatabaseService databaseService;

  CustomerLocalDatasource(
    this.databaseService,
  );

  Future<List<CustomerEntity>> getAll() async {
    return dummyCustomers;
    final Database db = await databaseService.database;

    final result = await db.query('customers');

    return result.map((e) => CustomerEntity.fromJson(e)).toList();
  }

  Future<void> create(
    CustomerEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.insert(
      'customers',
      item.toJson(),
    );
  }

  Future<void> update(
    CustomerEntity item,
  ) async {
    final Database db = await databaseService.database;

    await db.update(
      'customers',
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
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  final List<CustomerEntity> dummyCustomers = [
    CustomerEntity(
      id: '1',
      name: 'Rahim Uddin',
      phone: '01712345678',
      address: 'Dhaka, Mirpur',
      totalDue: 1200.50,
    ),
    CustomerEntity(
      id: '2',
      name: 'Karim Ahmed',
      phone: '01823456789',
      address: 'Chattogram, Agrabad',
      totalDue: 0,
    ),
    CustomerEntity(
      id: '3',
      name: 'Nusrat Jahan',
      phone: '01934567890',
      address: 'Sylhet, Zindabazar',
      totalDue: 550.00,
    ),
    CustomerEntity(
      id: '4',
      name: 'Abdul Karim',
      phone: '01645678901',
      address: 'Rajshahi, Boalia',
      totalDue: 300.75,
    ),
    CustomerEntity(
      id: '5',
      name: 'Shahriar Alam',
      phone: '01756789012',
      address: 'Khulna, Sonadanga',
      totalDue: 0,
    ),
    CustomerEntity(
      id: '6',
      name: 'Tania Sultana',
      phone: '01867890123',
      address: 'Barishal, Sadar',
      totalDue: 890.00,
    ),
    CustomerEntity(
      id: '7',
      name: 'Imran Hossain',
      phone: '01978901234',
      address: 'Rangpur, Modern',
      totalDue: 150.25,
    ),
    CustomerEntity(
      id: '8',
      name: 'Fahim Reza',
      phone: '01689012345',
      address: 'Dhaka, Uttara',
      totalDue: 0,
    ),
    CustomerEntity(
      id: '9',
      name: 'Mariam Akter',
      phone: '01790123456',
      address: 'Comilla, Cantonment',
      totalDue: 420.00,
    ),
    CustomerEntity(
      id: '10',
      name: 'Saiful Islam',
      phone: '01801234567',
      address: 'Gazipur, Tongi',
      totalDue: 75.00,
    ),
  ];
}
