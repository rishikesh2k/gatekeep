class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool isNetworkError;

  ApiException(this.message, {this.statusCode, this.isNetworkError = false});

  bool get isNotFound => statusCode == 404;

  @override
  String toString() => message;
}
