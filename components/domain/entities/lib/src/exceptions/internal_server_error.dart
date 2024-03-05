class InternalServerError implements Exception {
  const InternalServerError(this.message);

  final String message;

  @override
  String toString() => message;
}
