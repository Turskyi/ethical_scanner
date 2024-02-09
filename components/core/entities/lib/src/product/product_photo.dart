import 'package:entities/entities.dart';

class ProductImage {
  const ProductImage({
    required this.path,
    required this.info,
});

  final String path;
  final ProductInfo info;
}