import 'package:dio/dio.dart';
import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_sources/remote/remote_data_source_impl.dart';
import 'package:ethical_scanner/data/data_sources/remote/rest/logging_interceptor_impl.dart';
import 'package:ethical_scanner/data/data_sources/remote/rest/retrofit_client/retrofit_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() {
  group('RemoteDataSourceImpl', () {
    late RemoteDataSourceImpl remoteDataSource;

    setUp(() {
      OpenFoodAPIConfiguration.userAgent = UserAgent(
        name: 'ethical_scanner',
      );

      OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
        OpenFoodFactsLanguage.ENGLISH,
      ];

      OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.CANADA;
      final Dio dio = Dio();
      const LoggingInterceptor loggingInterceptor = LoggingInterceptorImpl();
      if (loggingInterceptor is Interceptor) {
        dio.interceptors.add(loggingInterceptor as Interceptor);
      }

      // Initialize the RemoteDataSourceImpl
      remoteDataSource = RemoteDataSourceImpl(RetrofitClient(dio));
    });

    test(
      'getProductInfoAsFuture returns ProductInfo on success',
      () async {
        // Arrange
        const String input = '0055577105436';
        const ProductInfo expectedResult = ProductInfo(
          barcode: input,
          countrySold: 'Canada',
        );

        // Act
        final ProductInfo result =
            await remoteDataSource.getProductInfoAsFuture(
          const LocalizedCode(code: input),
        );

        // Assert
        expect(result.countrySold, equals(expectedResult.countrySold));
        expect(result.barcode, equals(expectedResult.barcode));
      },
      timeout: const Timeout(Duration(seconds: 40)),
    );
  });
}
