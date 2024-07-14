import 'package:bloc/bloc.dart';
import 'package:interface_adapters/src/ui/modules/scan/scan_event.dart';
import 'package:use_cases/use_cases.dart';

part 'scan_view_model.dart';

class ScanPresenter extends Bloc<ScanEvent, ScanViewModel> {
  ScanPresenter(
    this._saveSoundPreferenceUseCase,
    this._getSoundPreferenceUseCase,
  ) : super(const LoadingScanningState()) {
    on<LoadScannerEvent>(
      (
        _,
        Emitter<ScanViewModel> emit,
      ) {
        emit(ScanningState(_getSoundPreferenceUseCase.call()));
      },
    );
    on<PopBarcodeEvent>(
      (PopBarcodeEvent event, Emitter<ScanViewModel> emit) {
        if (event.barcode != null) {
          emit(ScanSuccessState(event.barcode!));
        } else {
          emit(const CanceledScanningState());
        }
      },
    );
    on<NavigateBackEvent>(
      (_, Emitter<ScanViewModel> emit) {
        emit(const CanceledScanningState());
      },
    );

    on<SoundToggleEvent>((
      _,
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
    });

    on<DetectedBarcodeEvent>(
      (DetectedBarcodeEvent event, Emitter<ScanViewModel> emit) {
        if (state is ScanningState) {
          emit(
            DetectedBarcodeState(
              barcodeValue: event.barcodeValue,
              isSoundOn: (state as ScanningState).isSoundOn,
            ),
          );
        }
      },
    );
  }

  final SaveSoundPreferenceUseCase _saveSoundPreferenceUseCase;
  final GetSoundPreferenceUseCase _getSoundPreferenceUseCase;
}
