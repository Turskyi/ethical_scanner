class BadRequestError implements Exception {
  const BadRequestError(this.message);

  final String message;

  @override
  String toString() => message;
}
