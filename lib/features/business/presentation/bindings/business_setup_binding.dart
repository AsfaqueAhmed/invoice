import 'package:flutter_getx_app/core/database/database_service.dart';
import 'package:get/get.dart';

import '../../data/datasources/business_local_datasource.dart';
import '../../data/repositories/business_repository_impl.dart';
import '../../domain/repositories/business_repository.dart';
import '../controllers/business_setup_controller.dart';

class BusinessSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessRepository>(
      () => BusinessRepositoryImpl(BusinessLocalDatasource(DatabaseService())),
    );
    Get.lazyPut(() => BusinessSetupController(Get.find()));
  }
}
