import 'package:flutter_getx_app/core/database/database_service.dart';
import 'package:get/get.dart';

import '../../data/datasources/customer_local_datasource.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/repositories/customer_repository.dart';
import '../controllers/customer_list_controller.dart';

class CustomerListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerRepository>(
      () => CustomerRepositoryImpl(CustomerLocalDatasource(DatabaseService())),
    );
    Get.lazyPut(() => CustomerListController(Get.find()));
  }
}
