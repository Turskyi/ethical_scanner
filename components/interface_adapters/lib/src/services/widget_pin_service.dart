import 'package:flutter/services.dart';

/// The [WidgetPinService] communicates with the native Android platform
/// to request pinning the app widget to the home screen.
class WidgetPinService {
  const WidgetPinService();

  static const String _channelName = 'com.turskyi.ethical_scanner/widget';
  static const String _methodPinWidget = 'pinWidget';

  static const MethodChannel _channel = MethodChannel(_channelName);

  /// Requests the native platform to pin the widget.
  /// Returns `true` if the request was successfully sent and supported,
  /// or `false` otherwise.
  Future<bool> pinWidget() async {
    try {
      final Object? result = await _channel.invokeMethod<Object?>(
        _methodPinWidget,
      );
      if (result is bool) {
        return result;
      } else {
        return false;
      }
    } on PlatformException catch (_) {
      return false;
    } on MissingPluginException catch (_) {
      return false;
    }
  }
}
