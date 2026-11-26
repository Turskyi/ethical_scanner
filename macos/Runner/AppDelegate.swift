import Cocoa
import FlutterMacOS
import WidgetKit

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    if #available(macOS 14.0, *) {
      WidgetCenter.shared.reloadTimelines(ofKind: "EthicalScannerWidget")
    }
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
