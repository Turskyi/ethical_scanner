import 'package:dio/dio.dart';
import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_sources/remote/remote_data_source_impl.dart';
import 'package:ethical_scanner/data/data_sources/remote/rest/retrofit_client/retrofit_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  if (kDebugMode) {
    test('sends a query to the AI backend and receives a response', () async {
      final RemoteDataSourceImpl remoteDataSource = RemoteDataSourceImpl(
        RetrofitClient(Dio()),
      );

      final AiBarcodeInfoResponse response = await remoteDataSource
          .getInfoFromAiAsFuture('0000000000000');

      expect(response.info.trim(), isNotEmpty);
      expect(response.provider.trim(), isNotEmpty);
      debugPrint(
        'AI backend response from ${response.provider}'
        '${response.model.isNotEmpty ? ' (${response.model})' : ''}: '
        '${response.info}',
      );
    }, timeout: const Timeout(Duration(seconds: 60)));
  }
}
