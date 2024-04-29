import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:interface_adapters/src/ui/app/ethical_scanner_app.dart';
import 'package:interface_adapters/src/ui/res/color/gradients.dart';
import 'package:interface_adapters/src/ui/res/color/material_colors.dart';
import 'package:interface_adapters/src/ui/res/values/app_durations.dart';
import 'package:interface_adapters/src/ui/res/values/dimens.dart';
import 'package:interface_adapters/src/ui/res/values/strings.dart';

class Resources extends InheritedWidget {
  const Resources({
    super.key,
    required this.colors,
    required this.gradients,
    this.strings = const Strings(),
    this.dimens = const Dimens(),
    this.durations = const AppDurations(),
    required super.child,
  });

  final MaterialColors colors;
  final Gradients gradients;
  final Dimens dimens;
  final Strings strings;
  final AppDurations durations;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  /// Returns the nearest [Resources] widget in the ancestor tree of [context].
  ///
  /// This method asserts that the result is not `null`, as we expect the
  /// [Resources] widget to be always present in the [EthicalScannerApp].
  /// If the [Resources] widget is not found, a runtime exception is thrown.
  static Resources of(BuildContext context) {
    Resources? resources =
        context.dependOnInheritedWidgetOfExactType<Resources>();
    if (resources != null) {
      return resources;
    } else {
      throw Exception(
        'You should wrap your app with `Resources InheritedWidget` and pass '
        'the root app widget to the child parameter.',
      );
    }
  }
}
