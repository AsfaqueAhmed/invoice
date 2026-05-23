import 'package:get/get.dart';

import '../../../data/repositories/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository _repository;

  HomeController(this._repository);

  // ─── State ────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxString title = 'GetX App'.obs;
  final RxInt counter = 0.obs;

  // ─── Lifecycle ────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading(true);
    try {
      // final data = await _repository.getHomeData();
      // Use data to update state here
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
