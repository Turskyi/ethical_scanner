package com.turskyi.ethical_scanner

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.jvm.java

@Suppress("unused")
class MainActivity : FlutterActivity() {
    private val channel = "com.turskyi.ethical_scanner/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel,
        ).setMethodCallHandler { call, result ->
            if (call.method == "pinWidget") {
                val success = pinWidget()
                result.success(success)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun pinWidget(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val appWidgetManager =
                getSystemService(AppWidgetManager::class.java)
            val myProvider = ComponentName(
                this,
                ScanWidget::class.java,
            )
            if (appWidgetManager?.isRequestPinAppWidgetSupported == true) {
                appWidgetManager.requestPinAppWidget(
                    myProvider,
                    null,
                    null,
                )
                return true
            }
        }
        return false
    }
}
