import 'package:flutter_getx_app/core/database/database_service.dart';
import 'package:get/get.dart';

import '../../data/datasources/product_local_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../controllers/product_list_controller.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(ProductLocalDatasource(DatabaseService())),
    );
    Get.lazyPut(() => ProductListController(Get.find()));
  }
}
