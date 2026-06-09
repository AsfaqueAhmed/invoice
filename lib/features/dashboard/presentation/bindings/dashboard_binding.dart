import 'package:flutter_getx_app/core/database/database_service.dart';
import 'package:get/get.dart';

import '../../../business/data/datasources/business_local_datasource.dart';
import '../../../business/data/repositories/business_repository_impl.dart';
import '../../../business/domain/repositories/business_repository.dart';
import '../../../customer/data/datasources/customer_local_datasource.dart';
import '../../../customer/data/repositories/customer_repository_impl.dart';
import '../../../customer/domain/repositories/customer_repository.dart';
import '../../../invoice/data/datasources/invoice_item_local_datasource.dart';
import '../../../invoice/data/datasources/invoice_local_datasource.dart';
import '../../../invoice/data/repositories/invoice_repository_impl.dart';
import '../../../invoice/domain/repositories/invoice_repository.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    final db = DatabaseService();
    Get.lazyPut<InvoiceRepository>(
      () => InvoiceRepositoryImpl(
        InvoiceLocalDatasource(db),
        InvoiceItemLocalDatasource(db),
      ),
    );
    Get.lazyPut<CustomerRepository>(
      () => CustomerRepositoryImpl(CustomerLocalDatasource(db)),
    );
    Get.lazyPut<BusinessRepository>(
      () => BusinessRepositoryImpl(BusinessLocalDatasource(db)),
    );
    Get.lazyPut(() => DashboardController(
          Get.find(),
          Get.find(),
          Get.find(),
        ));
  }
}
