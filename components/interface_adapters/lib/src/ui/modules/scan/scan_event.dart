sealed class ScanEvent {
  const ScanEvent();
}

class PopBarcodeEvent extends ScanEvent {
  const PopBarcodeEvent(this.barcode);
  final String barcode;
}

class NavigateBackEvent extends ScanEvent {
  const NavigateBackEvent();
}
