import 'package:openfoodfacts/openfoodfacts.dart';

extension ProductResultV3Extension on ProductResultV3 {
  bool get isNonNullProductSuccessful {
    return (status == ProductResultV3.statusSuccess ||
            status == ProductResultV3.statusWarning) &&
        product != null;
  }
}
