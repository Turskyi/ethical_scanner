import 'dart:async';
import 'dart:io';

import 'package:entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart';
import 'package:interface_adapters/src/data_sources/local/local_data_source.dart';
import 'package:interface_adapters/src/data_sources/remote/remote_data_source.dart';
import 'package:interface_adapters/src/error_message_extractor.dart';
import 'package:use_cases/use_cases.dart';

class ProductInfoGatewayImpl implements ProductInfoGateway {
  const ProductInfoGatewayImpl(this._remoteDataSource, this._localDataSource);

  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  @override
  Future<ProductInfo> getProductInfoAsFuture(LocalizedCode input) {
    final String inputCode = input.code;
    return _remoteDataSource
        .getProductInfoAsFuture(input)
        .onError((Object? error, StackTrace stackTrace) {
      if (error is FormatException) {
        final Object? source = error.source;
        if (source is String) {
          debugPrint(
            'FormatException in $runtimeType caught at '
            '"getProductInfoAsFuture": ${extractErrorMessage(source)}.'
            '\nInput that caused error: "$source"'
            '\nStacktrace: $stackTrace',
          );
        }
      } else if (error is SocketException) {
        debugPrint('Error in $runtimeType: '
            '\nerror: ${error.runtimeType}.'
            '\nerror.message: ${error.message}.'
            '\nerror.address: ${error.address}.'
            '\nerror.osError: ${error.osError}.'
            '\nerror.port: ${error.port}.');
      } else if (error is ClientException) {
        debugPrint(
          'ClientException in $runtimeType during "getProductInfoAsFuture":'
          '\n  Message: ${error.message}'
          '\n  URI: ${error.uri}'
          '\n  Stacktrace: $stackTrace',
        );
      } else {
        debugPrint(
          'Unhandled error of type "${error.runtimeType}" in $runtimeType '
          'during "getProductInfoAsFuture":'
          '\n  Error: $error'
          '\n  Stacktrace: $stackTrace',
        );
      }

      final Language inputLanguage = input.language;
      if (_isBarcode(inputCode)) {
        return ProductInfo(barcode: inputCode, language: inputLanguage);
      } else if (_isWebsite(inputCode)) {
        return ProductInfo(website: inputCode, language: inputLanguage);
      } else if (_isAmazonAsin(inputCode)) {
        return ProductInfo(brand: 'Amazon', language: inputLanguage);
      } else if (error is NotFoundException) {
        throw error;
      } else {
        throw Exception(
          'Product information not found for barcode: $input.\nError: $error',
        );
      }
    }).then((ProductInfo info) {
      if (info.origin.isNotEmpty || info.countrySold.isNotEmpty) {
        return info;
      } else if (_localDataSource.isEnglishBook(inputCode)) {
        final String eanPrefix = inputCode.substring(0, 3);
        return info.copyWith(
          origin: translate(
            'product_info.initial_book_code_description',
            args: <String, Object?>{'eanPrefix': eanPrefix},
          ),
        );
      } else {
        final ProductInfo localInfo = info.copyWith(
          origin: _localDataSource.getCountryFromBarcode(inputCode),
        );
        if (localInfo.origin.isNotEmpty) {
          return localInfo;
        } else {
          return _remoteDataSource.getCountryFromAiAsFuture(inputCode).then(
                (String country) => info.copyWith(countryAi: country),
              );
        }
      }
    });
  }

  @override
  Future<void> addProduct(ProductInfo productInfo) {
    return _remoteDataSource.addProduct(productInfo);
  }

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
