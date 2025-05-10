import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:interface_adapters/src/ui/modules/scan/scan_event.dart';
import 'package:use_cases/use_cases.dart';

part 'scan_view_model.dart';

class ScanPresenter extends Bloc<ScanEvent, ScanViewModel> {
  ScanPresenter(
    this._saveSoundPreferenceUseCase,
    this._getSoundPreferenceUseCase,
  ) : super(const LoadingScanningState()) {
    on<LoadScannerEvent>(_onLoadScannerEvent);

    on<PopBarcodeEvent>(_onPopBarcodeEvent);

    on<NavigateBackEvent>(_onNavigateBackEvent);

    on<SoundToggleEvent>(_onSoundToggleEvent);

    on<DetectedBarcodeEvent>(_onDetectedBarcodeEvent);
  }

  final SaveSoundPreferenceUseCase _saveSoundPreferenceUseCase;
  final GetSoundPreferenceUseCase _getSoundPreferenceUseCase;

  FutureOr<void> _onDetectedBarcodeEvent(
    DetectedBarcodeEvent event,
    Emitter<ScanViewModel> emit,
  ) {
    if (state is ScanningState) {
      emit(
        DetectedBarcodeState(
          barcodeValue: event.barcodeValue,
          isSoundOn: (state as ScanningState).isSoundOn,
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
        emit((state as ScanningState).copyWith(isSoundOn));
      } else {
        emit(const LoadingScanningState());
      }
    }
  }

  FutureOr<void> _onLoadScannerEvent(
    LoadScannerEvent _,
    Emitter<ScanViewModel> emit,
  ) {
    emit(ScanningState(_getSoundPreferenceUseCase.call()));
  }

  FutureOr<void> _onPopBarcodeEvent(
    PopBarcodeEvent event,
    Emitter<ScanViewModel> emit,
  ) {
    if (event.barcode.isEmpty) {
      emit(const CanceledScanningState());
    } else {
      emit(ScanSuccessState(event.barcode));
    }
  }

  FutureOr<void> _onNavigateBackEvent(
    NavigateBackEvent _,
    Emitter<ScanViewModel> emit,
  ) {
    emit(const CanceledScanningState());
  }
}
