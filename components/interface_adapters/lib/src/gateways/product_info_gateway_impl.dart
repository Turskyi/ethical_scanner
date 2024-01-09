import 'dart:async';

import 'package:entities/entities.dart';
import 'package:interface_adapters/src/data_sources/local/local_data_source.dart';
import 'package:interface_adapters/src/data_sources/remote/remote_data_source.dart';
import 'package:use_cases/use_cases.dart';

class ProductInfoGatewayImpl implements ProductInfoGateway {
  const ProductInfoGatewayImpl(this._remoteDataSource, this._localDataSource);

  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  @override
  Future<ProductInfo> getProductInfoAsFuture(String barcode) =>
      _remoteDataSource
          .getProductInfoAsFuture(barcode)
          .then((ProductInfo info) {
        if (info.origin.isNotEmpty || info.country.isNotEmpty) {
          return info;
        } else if (_localDataSource.isEnglishBook(barcode)) {
          return info.copyWith(
            origin:
                'The initial ${barcode.substring(0, 3)} in this barcode is the '
                'Book-land EAN prefix, indicating that it is a book. The '
                '${barcode.substring(0, 3)} prefix, in this case, is '
                'assigned to the English language, but it doesn\'t specify '
                'a particular country.',
          );
        } else {
          ProductInfo localInfo = info.copyWith(
            origin: _localDataSource.getCountryFromBarcode(barcode),
          );
          if (localInfo.origin.isNotEmpty) {
            return localInfo;
          } else {
            return _remoteDataSource.getCountryFromAiAsFuture(barcode).then(
                  (String country) => info.copyWith(
                    countryAi: country,
                  ),
                );
          }
        }
      });
}
