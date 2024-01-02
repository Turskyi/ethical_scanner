import 'package:flutter/widgets.dart';
import 'package:interface_adapters/src/ui/res/color/gradients.dart';

class Resources extends InheritedWidget {
  const Resources({
    super.key,
    required this.gradients,
    required super.child,
  });

  final Gradients gradients;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static Resources of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: Resources)!;
}
