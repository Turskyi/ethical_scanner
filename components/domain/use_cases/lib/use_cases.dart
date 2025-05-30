/// [use_cases] library contains descriptions of the way that an
/// automated system is used.
/// [use_cases] specify the inputs to be
/// provided by the user, the outputs to be returned to the user.
/// A [use_cases] library describes application-specific business
/// rules.
library;

export 'src/gateways/product_info_gateway.dart';
export 'src/gateways/settings_gateway.dart';
export 'src/use_cases/add_ingredients_use_case.dart';
export 'src/use_cases/get_language_use_case.dart';
export 'src/use_cases/get_precipitation_state_use_case.dart';
export 'src/use_cases/get_product_info_use_case.dart';
export 'src/use_cases/get_sound_preference_use_case.dart';
export 'src/use_cases/save_language_use_case.dart';
export 'src/use_cases/save_precipitation_state_use_case.dart';
export 'src/use_cases/save_sound_preference_use_case.dart';
export 'src/use_cases/use_case.dart';
