import 'dart:io';

import 'package:entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interface_adapters/src/gateways/product_info_gateway_impl.dart';
import 'package:use_cases/use_cases.dart';

import 'failing_remote_data_source.dart';
import 'mock_local_data_source_impl.dart';

void main() {
  test('marks offline barcode lookup as offline without ingredients', () async {
    final ProductInfoGateway gateway = ProductInfoGatewayImpl(
      FailingRemoteDataSource(const SocketException('No internet connection')),
      MockLocalDataSourceImpl(),
    );

    final ProductInfo productInfo = await gateway.getProductInfoAsFuture(
      const LocalizedCode(code: '1950000000000'),
    );

    expect(productInfo.responseType, ProductResponseType.offline);
    expect(productInfo.hasIngredients, isFalse);
  });

  test('keeps other barcode lookup failures classified as errors', () async {
    final ProductInfoGateway gateway = ProductInfoGatewayImpl(
      FailingRemoteDataSource(StateError('Unexpected failure')),
      MockLocalDataSourceImpl(),
    );

    final ProductInfo productInfo = await gateway.getProductInfoAsFuture(
      const LocalizedCode(code: '1950000000000'),
    );

    expect(productInfo.responseType, ProductResponseType.error);
    expect(productInfo.hasIngredients, isFalse);
  });
}
