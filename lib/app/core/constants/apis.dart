/// All API base URLs and endpoint paths.
class ApiConstants {
  ApiConstants._();

  // ─── Base URLs ───────────────────────────────────────────────
  static const String baseUrl = 'https://api.yourapp.com/v1';
  static const String imageBaseUrl = 'https://cdn.yourapp.com';

  // ─── Timeouts ────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // ─── Auth ────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // ─── User ────────────────────────────────────────────────────
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update';

  // ─── Home ────────────────────────────────────────────────────
  static const String homeData = '/home';

  // ─── Helpers ─────────────────────────────────────────────────
  /// Build a full URL from an endpoint path.
  static String url(String endpoint) => '$baseUrl$endpoint';
}
