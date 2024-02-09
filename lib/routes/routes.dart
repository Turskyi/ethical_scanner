enum AppRoute {
  home,
  scan,
  photo,
  settings;

  String get path => switch (this) {
        AppRoute.home => '/',
        AppRoute.scan => '${AppRoute.home.path}${AppRoute.scan.name}',
        AppRoute.photo => '${AppRoute.home.path}${AppRoute.photo.name}',
        AppRoute.settings => '${AppRoute.home.path}${AppRoute.settings.name}',
      };
}

const String home = '/';
const String scan = '${home}scan';
const String photo = '${home}photo';
