import 'package:entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interface_adapters/src/data_sources/remote/remote_data_source.dart';

class FailingRemoteDataSource extends Fake implements RemoteDataSource {
  FailingRemoteDataSource(this.error);

  final Object error;

  @override
  Future<ProductInfo> getProductInfoAsFuture(LocalizedCode barcode) async {
    throw error;
  }
}
