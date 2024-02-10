import 'package:entities/entities.dart';

class ProductPhoto {
  const ProductPhoto({
    this.path = '',
    this.info = const ProductInfo(),
  });

  final String path;
  final ProductInfo info;

  @override
  String toString() => 'ProductPhoto{path: $path, info: $info}';
}
