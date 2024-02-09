import 'dart:async';
import 'dart:developer';

import 'package:entities/entities.dart';
import 'package:interface_adapters/src/data_sources/local/local_data_source.dart';
import 'package:interface_adapters/src/data_sources/remote/remote_data_source.dart';
import 'package:interface_adapters/src/error_message_extractor.dart';
import 'package:use_cases/use_cases.dart';

class ProductInfoGatewayImpl implements ProductInfoGateway {
  const ProductInfoGatewayImpl(this._remoteDataSource, this._localDataSource);

  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  @override
  Future<ProductInfo> getProductInfoAsFuture(Barcode input) {
    return _remoteDataSource
        .getProductInfoAsFuture(input)
        .onError((Object? error, StackTrace stackTrace) {
      if (error is FormatException && error.source is String) {
        log('Error in $runtimeType: ${extractErrorMessage(error.source)}.'
            '\nStacktrace: $stackTrace');
      }
      if (_isBarcode(input.code)) {
        return ProductInfo(barcode: input.code);
      } else if (_isWebsite(input.code)) {
        return ProductInfo(website: input.code);
      } else if (_isAmazonAsin(input.code)) {
        return const ProductInfo(brand: 'Amazon');
      }
      throw Exception(
        'Product information not found for barcode: $input.\nError: $error',
      );
    }).then((ProductInfo info) {
      if (info.origin.isNotEmpty || info.country.isNotEmpty) {
        return info;
      } else if (_localDataSource.isEnglishBook(input.code)) {
        return info.copyWith(
          origin:
              'The initial ${input.code.substring(0, 3)} in this barcode is '
              'the Book-land EAN prefix, indicating that it is a book. The '
              '${input.code.substring(0, 3)} prefix, in this case, is '
              'assigned to the English language, but it doesn\'t specify '
              'a particular country.',
        );
      } else {
        ProductInfo localInfo = info.copyWith(
          origin: _localDataSource.getCountryFromBarcode(input.code),
        );
        if (localInfo.origin.isNotEmpty) {
          return localInfo;
        } else {
          return _remoteDataSource.getCountryFromAiAsFuture(input.code).then(
                (String country) => info.copyWith(
                  countryAi: country,
                ),
              );
        }
      }
    });
  }

  @override
  Future<void> addProduct(ProductInfo productInfo) =>
      _remoteDataSource.addProduct(productInfo);

  @override
  Future<void> addIngredients(ProductPhoto productPhoto) {
    return _remoteDataSource.addIngredients(productPhoto);
  }

  bool _isWebsite(String input) {
    final RegExp regex = RegExp(
      r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]'
      r'{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$',
    );
    return regex.hasMatch(input);
  }

  /// Checks if the provided [barcode] is a valid Amazon ASIN.
  ///
  /// Amazon ASINs typically follow the pattern: A followed by 10 characters,
  /// which are typically alphanumeric.
  ///
  /// Returns `true` if [barcode] is a valid Amazon ASIN, and `false` otherwise.
  bool _isAmazonAsin(String barcode) {
    // ASIN pattern: A followed by 10 characters, typically alphanumeric
    RegExp asinPattern = RegExp(r'^[A-Z0-9]{10}$');
    return asinPattern.hasMatch(barcode);
  }

  bool _isBarcode(String input) {
    // Typical barcodes are between 8 and 14 digits long
    if (input.length < 8 || input.length > 14) {
      return false;
    }
    // Check if the string contains only digits
    for (int i = 0; i < input.length; i++) {
      if (input.codeUnitAt(i) < '0'.codeUnitAt(0) ||
          input.codeUnitAt(i) > '9'.codeUnitAt(0)) {
        return false;
      }
    }
    return true;
  }
}
