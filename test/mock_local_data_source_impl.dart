import 'package:ethical_scanner/data/data_sources/local/local_data_source_impl.dart';
import 'package:mockito/mockito.dart';

class MockLocalDataSourceImpl extends Mock implements LocalDataSourceImpl {
  @override
  Future<void> init() {
    return Future<void>.value();
  }
}
