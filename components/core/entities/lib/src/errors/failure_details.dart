class FailureDetails {
  const FailureDetails({this.httpCode, required this.message});

  final int? httpCode;
  final String message;
}