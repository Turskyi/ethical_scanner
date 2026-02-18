import 'package:entities/entities.dart';
import 'package:use_cases/use_cases.dart';

/// Interface for dependencies required by the interface adapters layer.
/// This allows the [interface_adapters] layer to remain independent of the
/// concrete implementation of dependencies in the [main] module.
abstract interface class AppDependencies {
  UseCase<bool, Null> get getPrecipitationStateUseCase;
  UseCase<Future<bool>, bool> get savePrecipitationStateUseCase;
  UseCase<Language, Object?> get getLanguageUseCase;
  UseCase<Future<bool>, String> get saveLanguageUseCase;
  UseCase<Future<ProductInfo>, LocalizedCode> get productInfoUseCase;
  UseCase<Future<void>, ProductPhoto> get addIngredientsUseCase;
  GetSoundPreferenceUseCase get getSoundPreferenceUseCase;
  SaveSoundPreferenceUseCase get saveSoundPreferenceUseCase;
}
