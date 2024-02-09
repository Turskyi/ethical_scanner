part of 'scan_presenter.dart';

sealed class ScanViewModel {
  const ScanViewModel();
}

class ScanningState extends ScanViewModel {
  const ScanningState() : super();
}

class ScanSuccessState extends ScanViewModel {
  const ScanSuccessState(this.barcode) : super();
  final String barcode;
}

class CanceledScanningState extends ScanViewModel {
  const CanceledScanningState() : super();
}
