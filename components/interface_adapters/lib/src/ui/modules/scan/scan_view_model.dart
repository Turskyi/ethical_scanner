part of 'scan_presenter.dart';

sealed class ScanViewModel {
  const ScanViewModel();
}

class LoadingScanningState extends ScanViewModel {
  const LoadingScanningState();
}

class ScanningState extends ScanViewModel {
  const ScanningState(this.isSoundOn);

  final bool isSoundOn;

  ScanningState copyWith(bool? isSoundOn) =>
      ScanningState(isSoundOn ?? this.isSoundOn);
}

class ScanSuccessState extends ScanViewModel {
  const ScanSuccessState(this.barcode);

  final String barcode;
}

class CanceledScanningState extends ScanViewModel {
  const CanceledScanningState();
}

class DetectedBarcodeState extends ScanViewModel {
  const DetectedBarcodeState({
    required this.barcodeValue,
    required this.isSoundOn,
  });

  final String barcodeValue;
  final bool isSoundOn;
}
