import 'package:entities/src/errors/exception_details.dart';
import 'package:entities/src/errors/failure_details.dart';
import 'package:entities/src/status.dart';

class Resource<T> {
  const Resource(
    this.data,
    this.status, {
    this.failureDetails,
    this.exceptionDetails,
  });

  final T? data;
  final Status status;
  final FailureDetails? failureDetails;
  final ExceptionDetails? exceptionDetails;

  static loading<T>([T? data]) => Resource<T>(data, Status.loading);

  static success<T>(T data) => Resource<T>(data, Status.success);

  static failure<T>(dynamic data, FailureDetails failureDetails) =>
      Resource<T>(data, Status.failure, failureDetails: failureDetails);

  Resource<T> addData(Status newStatus, T? newData, {FailureDetails? error}) {
    return Resource<T>(
      newData,
      newStatus,
      failureDetails: error,
    );
  }

  static Future<Resource<T>> asFuture<T>(Future<T> Function() req) async {
    try {
      final T res = await req();
      return Resource.success<T>(res);
    } catch (e) {
      final FailureDetails errorMapped = _errorMapper(e);
      return Resource.failure<T>(null, errorMapped);
    }
  }

  static FailureDetails Function(dynamic e) get _errorMapper => (dynamic e) {
    return FailureDetails(message: e.toString());
  };
}
