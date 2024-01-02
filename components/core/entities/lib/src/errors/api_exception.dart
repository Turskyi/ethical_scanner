import 'package:entities/src/errors/network_error.dart';

class ApiException implements Exception {
  const ApiException({this.errorCode, required this.response});

  final int? errorCode;
  final NetworkError response;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiException &&
          runtimeType == other.runtimeType &&
          errorCode == other.errorCode;

  @override
  int get hashCode => errorCode.hashCode;

  @override
  String toString() => response.toString();
}
