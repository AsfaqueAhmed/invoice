import 'package:flutter_getx_app/core/database/database_service.dart';
import 'package:get/get.dart';

import '../../../customer/data/datasources/customer_local_datasource.dart';
import '../../../customer/data/repositories/customer_repository_impl.dart';
import '../../../customer/domain/repositories/customer_repository.dart';
import '../../../product/data/datasources/product_local_datasource.dart';
import '../../../product/data/repositories/product_repository_impl.dart';
import '../../../product/domain/repositories/product_repository.dart';
import '../../data/datasources/invoice_item_local_datasource.dart';
import '../../data/datasources/invoice_local_datasource.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../controllers/create_invoice_controller.dart';

class CreateInvoiceBinding extends Bindings {
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
    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(ProductLocalDatasource(db)),
    );
    Get.lazyPut(() => CreateInvoiceController(
          Get.find(),
          Get.find(),
          Get.find(),
        ));
  }
}
