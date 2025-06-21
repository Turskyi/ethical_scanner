/// Exception thrown when even the backup user fails to upload an image due to
/// a forbidden status.
class BackupUserForbiddenException implements Exception {
  const BackupUserForbiddenException({
    required this.message,
    this.barcode,
    this.attemptedUserId,
  });

  final String message;
  final String? barcode;

  /// The ID of the backup user that failed.
  final String? attemptedUserId;

  @override
  String toString() {
    String output = 'BackupUserForbiddenException: $message';
    if (barcode != null) {
      output += '\nBarcode: $barcode';
    }
    if (attemptedUserId != null) {
      output += '\nAttempted Backup User ID: $attemptedUserId';
    }
    return output;
  }
}
