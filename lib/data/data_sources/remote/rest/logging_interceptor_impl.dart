import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:entities/entities.dart';

class LoggingInterceptorImpl extends Interceptor implements LoggingInterceptor {
  const LoggingInterceptorImpl();

  @override
  void onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) {
    log('onResponse ------------------');
    final String respStr = response.toString();
    const int maxLength = 2000;
    final String responseLog = respStr.length > maxLength
        ? '${respStr.substring(0, maxLength ~/ 2)}...'
              '${respStr.substring(respStr.length - maxLength ~/ 2)}'
        : respStr;
    log('-$responseLog----------------------------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('onError ---------------------');
    log('ERROR: ${err.message}');
    log('BODY: ${err.response}', stackTrace: err.stackTrace);
    log('-----------------------------');
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('onRequest --------------------');
    log('URI: ${options.uri.toString()}');
    log('PARAMS: ${options.queryParameters.toString()}');
    log('HEADERS: ${options.headers.toString()}');
    log('-----------------------------');
    super.onRequest(options, handler);
  }
}
