sealed class ScanEvent {
  const ScanEvent();
}

class LoadScannerEvent extends ScanEvent {
  const LoadScannerEvent();
}

class PopBarcodeEvent extends ScanEvent {
  const PopBarcodeEvent(this.barcode);

  final String barcode;
}

class NavigateBackEvent extends ScanEvent {
  const NavigateBackEvent();
}

class SoundToggleEvent extends ScanEvent {
  const SoundToggleEvent();
}

class DetectedBarcodeEvent extends ScanEvent {
  const DetectedBarcodeEvent(this.barcodeValue);

  final String barcodeValue;
}
