enum AppRoute { home, scan, settings }

extension RouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.home:
        return '/';
      case AppRoute.scan:
        return '${AppRoute.home.path}scan';
      case AppRoute.settings:
        return '${AppRoute.home.path}settings';
    }
  }
}
