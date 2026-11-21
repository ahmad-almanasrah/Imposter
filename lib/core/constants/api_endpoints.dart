/// Application API configuration and endpoint paths
abstract final class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com/v1';

  // Request Timeouts
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration connectionTimeout = Duration(seconds: 15);

  // Endpoints
  static const String items = '/items';
  static const String auth = '/auth';
  static const String profile = '/profile';
}
