import '../providers/home_provider.dart';

class HomeRepository {
  final HomeProvider _provider;

  HomeRepository(this._provider);

  Future<Map<String, dynamic>?> getHomeData() async {
    final response = await _provider.fetchHomeData();
    if (response.statusCode == 200) {
      return response.body as Map<String, dynamic>;
    }
    return null;
  }
}
