part of 'scan_presenter.dart';

sealed class ScanViewModel {
  const ScanViewModel({required this.language});

  final Language language;

  bool get isScanningWithSound =>
      this is ScanningState && (this as ScanningState).isSoundOn;
}

class LoadingScanningState extends ScanViewModel {
  const LoadingScanningState({required super.language});
}

class ScanningState extends ScanViewModel {
  const ScanningState({required super.language, required this.isSoundOn});

  final bool isSoundOn;

  ScanningState copyWith({
    bool? isSoundOn,
    Language? language,
  }) {
    return ScanningState(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      language: language ?? this.language,
    );
  }
}

class ScanSuccessState extends ScanViewModel {
  const ScanSuccessState({required super.language, required this.barcode});

  final String barcode;
}

class CanceledScanningState extends ScanViewModel {
  const CanceledScanningState({required super.language});
}

class DetectedBarcodeState extends ScanViewModel {
  const DetectedBarcodeState({
    required super.language,
    required this.barcodeValue,
    required this.isSoundOn,
  });

  final String barcodeValue;
  final bool isSoundOn;
}
