/// Exception thrown when a connection to a critical API endpoint is refused.
class ApiConnectionRefusedException implements Exception {
  const ApiConnectionRefusedException({
    required this.message,
    this.attemptedUri,
    this.originalExceptionMessage,
  });

  final String message;
  final Uri? attemptedUri;
  final String? originalExceptionMessage;

  @override
  String toString() {
    String output = 'ApiConnectionRefusedException: $message';
    if (attemptedUri != null) {
      output += '\nAttempted URI: $attemptedUri';
    }
    if (originalExceptionMessage != null &&
        originalExceptionMessage!.isNotEmpty) {
      output += '\nOriginal Error: $originalExceptionMessage';
    }
    return output;
  }
}
