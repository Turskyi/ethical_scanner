import 'package:dio/dio.dart';
import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_sources/local/local_data_source_impl.dart';
import 'package:ethical_scanner/data/data_sources/remote/remote_data_source_impl.dart';
import 'package:ethical_scanner/data/data_sources/remote/rest/logging_interceptor_impl.dart';
import 'package:ethical_scanner/data/data_sources/remote/rest/retrofit_client/retrofit_client.dart';
import 'package:ethical_scanner/di/dependencies.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:mockito/mockito.dart';
import 'package:use_cases/use_cases.dart';

import 'mock_local_data_source_impl.dart';

class MockDependencies extends Mock implements Dependencies {
  MockDependencies._(this._localDataSource);

  final LocalDataSourceImpl _localDataSource;

  static Future<MockDependencies> create() async {
    final MockLocalDataSourceImpl localDataSource = MockLocalDataSourceImpl();
    await localDataSource.init();
    return MockDependencies._(localDataSource);
  }

  RestClient get _restClient {
    final Dio dio = Dio();
    const LoggingInterceptor loggingInterceptor = LoggingInterceptorImpl();
    if (loggingInterceptor is Interceptor) {
      dio.interceptors.add(loggingInterceptor as Interceptor);
    }
    return RetrofitClient(dio);
  }

  ProductInfoGateway get _productInfoGateway => ProductInfoGatewayImpl(
        RemoteDataSourceImpl(_restClient),
        _localDataSource,
      );

  @override
  UseCase<Future<ProductInfo>, Barcode> get productInfoUseCase =>
      GetProductInfoUseCase(_productInfoGateway);
}
