// Override without editing code:
// flutter run --dart-define=API_BASE_URL=https://xxxx.mockapi.io/gatekeep/api/v1
class ApiConstants {
  static const String placeholderUrl = 'https://YOUR_PROJECT_ID.mockapi.io/api/v1';

  static const String apiUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://6ae0e97dbe3bc8fead9814ac.mockapi.io/gatekeep/api/v1',
  );

  // Resource name on this MockAPI project. Full list URL ends in /name.
  static const String visitors = '/name';

  static const Duration timeout = Duration(seconds: 15);

  static bool get isConfigured => apiUrl != placeholderUrl && apiUrl.isNotEmpty;
}
