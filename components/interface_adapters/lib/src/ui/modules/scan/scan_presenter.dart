import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:entities/entities.dart';
import 'package:interface_adapters/src/ui/modules/scan/scan_event.dart';
import 'package:use_cases/use_cases.dart';

part 'scan_view_model.dart';

class ScanPresenter extends Bloc<ScanEvent, ScanViewModel> {
  ScanPresenter(
    this._saveSoundPreferenceUseCase,
    this._getSoundPreferenceUseCase,
    this._saveLanguageUseCase,
    Language initialLanguage,
  ) : super(LoadingScanningState(language: initialLanguage)) {
    on<LoadScannerEvent>(_onLoadScannerEvent);

    on<PopBarcodeEvent>(_onPopBarcodeEvent);

    on<NavigateBackEvent>(_onNavigateBackEvent);

    on<SoundToggleEvent>(_onSoundToggleEvent);

    on<DetectedBarcodeEvent>(_onDetectedBarcodeEvent);

    on<ChangeScanLanguageEvent>(_changeLanguage);
  }

  final SaveSoundPreferenceUseCase _saveSoundPreferenceUseCase;
  final GetSoundPreferenceUseCase _getSoundPreferenceUseCase;
  final UseCase<Future<bool>, String> _saveLanguageUseCase;

  FutureOr<void> _onDetectedBarcodeEvent(
    DetectedBarcodeEvent event,
    Emitter<ScanViewModel> emit,
  ) {
    if (state is ScanningState) {
      emit(
        DetectedBarcodeState(
          barcodeValue: event.barcodeValue,
          isSoundOn: (state as ScanningState).isSoundOn,
          language: state.language,
        ),
      );
    }
  }

  FutureOr<void> _onSoundToggleEvent(
    SoundToggleEvent _,
    Emitter<ScanViewModel> emit,
  ) async {
    if (state is ScanningState) {
      bool isSoundOn = !(state as ScanningState).isSoundOn;
      bool isSaved = await _saveSoundPreferenceUseCase.call(isSoundOn);
      if (isSaved) {
        emit((state as ScanningState).copyWith(isSoundOn: isSoundOn));
      } else {
        emit(LoadingScanningState(language: state.language));
      }
    }
  }

  FutureOr<void> _onLoadScannerEvent(
    LoadScannerEvent _,
    Emitter<ScanViewModel> emit,
  ) {
    final bool isSoundOn = _getSoundPreferenceUseCase.call();
    emit(ScanningState(language: state.language, isSoundOn: isSoundOn));
  }

  FutureOr<void> _onPopBarcodeEvent(
    PopBarcodeEvent event,
    Emitter<ScanViewModel> emit,
  ) {
    if (event.barcode.isEmpty) {
      emit(CanceledScanningState(language: state.language));
    } else {
      emit(ScanSuccessState(language: state.language, barcode: event.barcode));
    }
  }

  FutureOr<void> _onNavigateBackEvent(
    NavigateBackEvent _,
    Emitter<ScanViewModel> emit,
  ) {
    emit(CanceledScanningState(language: state.language));
  }

  FutureOr<void> _changeLanguage(
    ChangeScanLanguageEvent event,
    Emitter<ScanViewModel> emit,
  ) async {
    final Language language = event.language;
    if (language != state.language) {
      final bool isSaved = await _saveLanguageUseCase.call(
        language.isoLanguageCode,
      );
      if (isSaved && state is ScanningState) {
        emit((state as ScanningState).copyWith(language: language));
      } else {
        emit(LoadingScanningState(language: state.language));
      }
    }
  }
}
