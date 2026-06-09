import 'package:flutter_getx_app/core/database/database_service.dart';
import 'package:get/get.dart';

import '../../../business/data/datasources/business_local_datasource.dart';
import '../../../business/data/repositories/business_repository_impl.dart';
import '../../../business/domain/repositories/business_repository.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessRepository>(
      () => BusinessRepositoryImpl(BusinessLocalDatasource(DatabaseService())),
    );
    Get.lazyPut(() => SettingsController(Get.find()));
  }
}
