import 'package:get/get.dart';

import 'package:flutter_getx_app/features/invoices/data/datasources/invoice_item_local_datasource.dart';
import 'package:flutter_getx_app/features/invoices/data/datasources/invoice_local_datasource.dart';
import 'package:flutter_getx_app/features/invoices/data/repositories/invoice_repository.dart';

import '../../data/datasources/local/business_local_datasource.dart';
import '../../data/datasources/local/customer_local_datasource.dart';
import '../../data/datasources/local/product_local_datasource.dart';
import '../../data/repositories/business_repository.dart';
import '../../data/repositories/customer_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../database/database_service.dart';

/// Registers the data layer once at app start so every feature shares the
/// same `DatabaseService`/datasource/repository instances via `Get.find()`
/// instead of each controller instantiating its own copies.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DatabaseService>(DatabaseService(), permanent: true);

    Get.lazyPut<CustomerLocalDatasource>(
      () => CustomerLocalDatasource(Get.find<DatabaseService>()),
      fenix: true,
    );
    Get.lazyPut<ProductLocalDatasource>(
      () => ProductLocalDatasource(Get.find<DatabaseService>()),
      fenix: true,
    );
    Get.lazyPut<BusinessLocalDatasource>(
      () => BusinessLocalDatasource(Get.find<DatabaseService>()),
      fenix: true,
    );
    Get.lazyPut<InvoiceLocalDatasource>(
      () => InvoiceLocalDatasource(Get.find<DatabaseService>()),
      fenix: true,
    );
    Get.lazyPut<InvoiceItemLocalDatasource>(
      () => InvoiceItemLocalDatasource(Get.find<DatabaseService>()),
      fenix: true,
    );

    Get.lazyPut<CustomerRepository>(
      () => CustomerRepository(Get.find<CustomerLocalDatasource>()),
      fenix: true,
    );
    Get.lazyPut<ProductRepository>(
      () => ProductRepository(Get.find<ProductLocalDatasource>()),
      fenix: true,
    );
    Get.lazyPut<BusinessRepository>(
      () => BusinessRepository(Get.find<BusinessLocalDatasource>()),
      fenix: true,
    );
    Get.lazyPut<InvoiceRepository>(
      () => InvoiceRepository(
        Get.find<DatabaseService>(),
        Get.find<InvoiceLocalDatasource>(),
        Get.find<InvoiceItemLocalDatasource>(),
      ),
      fenix: true,
    );
  }
}
