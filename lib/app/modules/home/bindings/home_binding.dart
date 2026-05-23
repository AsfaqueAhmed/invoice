import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/providers/home_provider.dart';
import '../../../data/repositories/home_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeProvider>(() => HomeProvider());
    Get.lazyPut<HomeRepository>(() => HomeRepository(Get.find()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}
