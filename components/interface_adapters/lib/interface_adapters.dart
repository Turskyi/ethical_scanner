/// The software in the [interface_adapters] layer is a set of
/// adapters that convert data from the format most convenient for the use
/// cases and entities, to the format most convenient for some external agency
/// such as the database or the web.
/// The presenters, views, and controllers all belong in the
/// [interface_adapters] layer.
/// No code inward of this layer should know anything at all about the database.
library;

export 'src/data_sources/local/local_data_source.dart';
export 'src/data_sources/remote/remote_data_source.dart';
export 'src/env/env.dart';
export 'src/gateways/product_info_gateway_impl.dart';
export 'src/gateways/settings_gateway_impl.dart';
export 'src/router/routes.dart';
export 'src/ui/app/app.dart';
export 'src/ui/modules/home/home_presenter.dart';
export 'src/ui/modules/home/view/home_view.dart';
export 'src/ui/modules/photo/photo_presenter.dart';
export 'src/ui/modules/photo/view/photo_view.dart';
export 'src/ui/modules/privacy/view/privacy_view.dart';
export 'src/ui/modules/scan/scan_event.dart';
export 'src/ui/modules/scan/scan_presenter.dart';
export 'src/ui/modules/scan/view/scan_view.dart';
export 'src/ui/modules/support/view/support_view.dart';
export 'src/ui/res/enums/animation_constants.dart';
export 'src/ui/res/enums/duration_seconds.dart';
