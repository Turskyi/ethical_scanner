import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:interface_adapters/src/di/app_dependencies.dart';

/// {@template dependencies_scope}
/// A widget which is responsible for providing the dependencies.
/// {@endtemplate}
class DependenciesScope extends InheritedWidget {
  /// {@macro dependencies_scope}
  const DependenciesScope({
    required this.dependencies,
    required super.child,
    super.key,
  });

  /// The dependencies
  final AppDependencies dependencies;

  /// Get the dependencies from the [context].
  ///
  /// By default, this does not listen for changes ([listen] = false) because
  /// dependencies are typically initialized once and do not change during the
  /// application lifecycle. This also prevents "Tried to listen to an
  /// InheritedWidget in a life-cycle that will never be called again" errors
  /// when used inside Bloc/Provider `create` methods.
  static AppDependencies of(BuildContext context, {bool listen = false}) {
    final DependenciesScope? result = listen
        ? context.dependOnInheritedWidgetOfExactType<DependenciesScope>()
        : context.getInheritedWidgetOfExactType<DependenciesScope>();

    if (result == null) {
      throw StateError('No DependenciesScope found in context');
    }

    return result.dependencies;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<AppDependencies>('dependencies', dependencies),
    );
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
