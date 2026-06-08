import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/core/providers/shared_repository_providers.dart';
import 'datasources/invoice_item_local_datasource.dart';
import 'datasources/invoice_local_datasource.dart';
import 'repositories/invoice_repository.dart';

/// Wires up the invoices feature's data layer: datasources and repository
/// all share the single `DatabaseService` instance.

final invoiceLocalDatasourceProvider = Provider<InvoiceLocalDatasource>((ref) {
  return InvoiceLocalDatasource(ref.watch(databaseServiceProvider));
});

final invoiceItemLocalDatasourceProvider =
    Provider<InvoiceItemLocalDatasource>((ref) {
  return InvoiceItemLocalDatasource(ref.watch(databaseServiceProvider));
});

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository(
    ref.watch(databaseServiceProvider),
    ref.watch(invoiceLocalDatasourceProvider),
    ref.watch(invoiceItemLocalDatasourceProvider),
  );
});
