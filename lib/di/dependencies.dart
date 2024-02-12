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
  const Dependencies._(this._localDataSource);

  final LocalDataSourceImpl _localDataSource;

  static Future<Dependencies> create() async {
    final LocalDataSourceImpl localDataSource = LocalDataSourceImpl();
    await localDataSource.init();
    return Dependencies._(localDataSource);
  }

  UseCase<bool, Null> get getPrecipitationStateUseCase =>
      GetPrecipitationStateUseCase(_settingsGateway);

  UseCase<Language, Null> get getLanguageUseCase =>
      GetLanguageUseCase(_settingsGateway);

  UseCase<Future<bool>, bool> get savePrecipitationStateUseCase =>
      SavePrecipitationStateUseCase(_settingsGateway);

  UseCase<Future<bool>, String> get saveLanguageUseCase =>
      SaveLanguageUseCase(_settingsGateway);

  UseCase<Future<ProductInfo>, Barcode> get productInfoUseCase =>
      GetProductInfoUseCase(_productInfoGateway);

  UseCase<Future<void>, ProductPhoto> get addIngredientsUseCase =>
      AddIngredientsUseCase(_productInfoGateway);

  GetSoundPreferenceUseCase get getSoundPreferenceUseCase =>
      GetSoundPreferenceUseCase(_settingsGateway);

  SaveSoundPreferenceUseCase get saveSoundPreferenceUseCase =>
      SaveSoundPreferenceUseCase(_settingsGateway);

  SettingsGateway get _settingsGateway => SettingsGatewayImpl(_localDataSource);

  ProductInfoGateway get _productInfoGateway => ProductInfoGatewayImpl(
        RemoteDataSourceImpl(_restClient),
        _localDataSource,
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
