import 'package:bloc/bloc.dart';
import 'package:interface_adapters/src/ui/modules/scan/scan_event.dart';

part 'scan_view_model.dart';

class ScanPresenter extends Bloc<ScanEvent, ScanViewModel> {
  ScanPresenter() : super(const ScanningState()) {
    on<PopBarcodeEvent>(
      (PopBarcodeEvent event, Emitter<ScanViewModel> emit) =>
          emit(ScanSuccessState(event.barcode)),
    );
    on<NavigateBackEvent>(
      (_, Emitter<ScanViewModel> emit) => emit(const ScanFailureState()),
    );
  }
}
