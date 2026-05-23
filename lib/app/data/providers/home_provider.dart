import 'package:get/get.dart';
import 'base_provider.dart';
import '../../core/constants/apis.dart';

class HomeProvider extends BaseProvider {
  Future<Response> fetchHomeData() => get(ApiConstants.homeData);
}
