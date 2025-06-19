/// Generic exception for API communication issues.
class ApiException implements Exception {
  const ApiException({required this.message, this.uri, this.statusCode});

  final String message;
  final Uri? uri;
  final int? statusCode;

  @override
  String toString() {
    return 'ApiException: $message (URI: $uri, Status Code: $statusCode)';
  }
}
