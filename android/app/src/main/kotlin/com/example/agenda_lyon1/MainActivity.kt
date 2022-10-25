package com.example.agenda_lyon1

import android.app.NotificationChannel
import android.app.NotificationManager
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val ALARM_CHANEL = "alarmChannel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannels()
    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ALARM_CHANEL)

        channel.setMethodCallHandler { call, res ->

            when (call.method) {
                "setAlarm" -> {
                    var success = false
                    call.argument<Long>("time")?.let { time ->
                        var enabled = call.argument<Boolean>("enabled")
                        if (enabled == null) {
                            enabled = true
                        }
                        Alarm.setAlarm(
                            context,
                            time,
                            time.toString(),
                            if (enabled) Alarm.START else Alarm.NONE
                        )
                        success = true
                    }
                    res.success(success)
                }
                "cancelAlarm" -> {
                    var success = false
                    call.argument<Long>("time")?.let { time ->
                        Alarm.cancelAlarm(context, time.toString())
                        success = true
                    }
                    res.success(success)
                }

                else -> res.notImplemented()
            }
        }
    }


    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = getSystemService(NotificationManager::class.java)
            val channelAlarmNotif = NotificationChannel(
                Notif.ALARM_NOTIFICATION_ID,
                "Notification alarms",
                NotificationManager.IMPORTANCE_HIGH
            )

            channelAlarmNotif.enableLights(true)
            channelAlarmNotif.lightColor = Color.BLUE
            channelAlarmNotif.enableVibration(true)
            channelAlarmNotif.description = "Don't disable"
            notificationManager.createNotificationChannel(channelAlarmNotif)
        } else {
            TODO("VERSION.SDK_INT < O")
        }


    }
}
