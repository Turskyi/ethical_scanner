package com.turskyi.ethical_scanner

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.widget.RemoteViews
import java.util.Calendar

class ScanWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val views = RemoteViews(context.packageName, R.layout.scan_widget)

    val month = Calendar.getInstance().get(Calendar.MONTH) + 1 // 1-12
    val seasonalSymbol = when (month) {
        12, 1, 2 -> "❄️"
        3, 4, 5 -> "🌸"
        6, 7, 8 -> "🦋"
        9, 10, 11 -> "🍁"
        else -> "🍁"
    }

    views.setTextViewText(R.id.text_seasonal_top, seasonalSymbol)
    views.setTextViewText(R.id.text_seasonal_bottom, seasonalSymbol)

    val intent = Intent(context, MainActivity::class.java).apply {
        action = "es.antonborri.home_widget.action.LAUNCH"
        data = Uri.parse("ethicalscanner://scan")
        flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
    }

    val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    } else {
        PendingIntent.FLAG_UPDATE_CURRENT
    }

    val pendingIntent = PendingIntent.getActivity(context, 0, intent, flags)
    views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

    appWidgetManager.updateAppWidget(appWidgetId, views)
}