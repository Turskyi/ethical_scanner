class NetworkError {
  const NetworkError({
    this.errorId = '',
    required this.status,
    required this.info,
  });

  final String errorId;
  final String status;
  final String info;
}
