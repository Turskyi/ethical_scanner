import 'package:dio/dio.dart';
import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_sources/local/local_data_source_impl.dart';
import 'package:ethical_scanner/data/data_sources/remote/remote_data_source_impl.dart';
import 'package:ethical_scanner/data/data_sources/remote/rest/dio/logging_interceptor_impl.dart';
import 'package:ethical_scanner/data/data_sources/remote/rest/retrofit_client/retrofit_client.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:use_cases/use_cases.dart';

/// Dependencies container
class Dependencies {
  const Dependencies();

  UseCase<bool, Null> get getPrecipitationStateUseCase =>
      GetPrecipitationStateUseCase(
        SettingsGatewayImpl(LocalDataSourceImpl()),
      );

  UseCase<Future<bool>, bool> get savePrecipitationStateUseCase =>
      SavePrecipitationStateUseCase(
        SettingsGatewayImpl(LocalDataSourceImpl()),
      );

  UseCase<Future<ProductInfo>, String> get productInfoUseCase =>
      GetProductInfoUseCase(
        ProductInfoGatewayImpl(
          RemoteDataSourceImpl(_restClient),
          LocalDataSourceImpl(),
        ),
      );

  RestClient get _restClient {
    final Dio dio = Dio();
    const LoggingInterceptor loggingInterceptor = LoggingInterceptorImpl();
    if (loggingInterceptor is Interceptor) {
      dio.interceptors.add(loggingInterceptor as Interceptor);
    }
    return RetrofitClient(dio);
  }
}
