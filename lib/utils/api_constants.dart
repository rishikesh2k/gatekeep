
class ApiConstants {
  static const String apiUrl =
      'https://6ae0e97dbe3bc8fead9814ac.mockapi.io/gatekeep/api/v1';

  static const String visitors = '/name';

  static const Duration timeout = Duration(seconds: 15);

  static bool get isConfigured => apiUrl.isNotEmpty;
}
