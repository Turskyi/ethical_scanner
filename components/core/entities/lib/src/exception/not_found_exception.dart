class NotFoundException implements Exception {
  const NotFoundException(this.message);

  final String message;

  @override
  String toString() => message;
}
