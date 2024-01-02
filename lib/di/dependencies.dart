import 'package:entities/entities.dart';
import 'package:ethical_scanner/data/data_sources/local/local_data_source_impl.dart';
import 'package:ethical_scanner/data/data_sources/remote/remote_data_source_impl.dart';
import 'package:interface_adapters/interface_adapters.dart';
import 'package:use_cases/use_cases.dart';

/// Dependencies container
class Dependencies {
  const Dependencies();

  final UseCase<Future<ProductInfo>, String> getProductInfoUseCase =
      const GetProductInfoUseCase(
    ProductInfoGatewayImpl(
      RemoteDataSourceImpl(),
      LocalDataSourceImpl(),
    ),
  );
}
