import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/customer_local_datasource.dart';
import '../../data/datasources/local/product_local_datasource.dart';
import '../../data/repositories/customer_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../database/database_service.dart';

/// Riverpod providers for repositories that other features (e.g. invoices)
/// depend on but that haven't been migrated to Riverpod yet.
///
/// `DatabaseService` is a singleton, so this simply hands out the same
/// instance the GetX `InitialBinding` uses — no double DB connections.
/// As the customer/product features get refactored, their providers should
/// move into `features/customer` and `features/product` respectively, and
/// these entries can be removed.

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final datasource = CustomerLocalDatasource(ref.watch(databaseServiceProvider));
  return CustomerRepository(datasource);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final datasource = ProductLocalDatasource(ref.watch(databaseServiceProvider));
  return ProductRepository(datasource);
});
