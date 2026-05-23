import 'package:get/get.dart';
import '../../core/constants/apis.dart';

/// Base network provider using GetConnect.
/// All feature-specific providers extend this.
class BaseProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;
    httpClient.timeout = ApiConstants.connectTimeout;

    // Add auth token to every request automatically
    httpClient.addRequestModifier<dynamic>((request) async {
      // TODO: Replace with your real token storage (e.g. GetStorage / SharedPrefs)
      // final token = box.read('token');
      // if (token != null) request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      return request;
    });

    // Global response error handling
    httpClient.addResponseModifier((request, response) async {
      if (response.statusCode == 401) {
        // Token expired — navigate to login
        Get.offAllNamed('/login');
      }
      return response;
    });

    super.onInit();
  }
}
