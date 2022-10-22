package com.example.agenda_lyon1

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import androidx.annotation.DrawableRes
import androidx.core.app.NotificationCompat

class Notif(context: Context, private val channelId: String, title: String?, msg: String?, @DrawableRes icon: Int, pendingIntent: PendingIntent?) :
    NotificationCompat.Builder(context, channelId) {
    private val mNotificationManager: NotificationManager


    init {
        setSmallIcon(icon)
        setContentTitle(title)
        setContentText(msg)
        setAutoCancel(true)
        setContentIntent(pendingIntent)
        mNotificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    }

    fun show() {
        mNotificationManager.notify(
            if (channelId == NotificationChannels.ALARM_NOTIFICATION_ID) {
                0
            } else {
                System.currentTimeMillis().toInt()
            }, build()
        )
    }

    companion object {
        fun cancelAlarmNotif(context: Context) {
            (context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).cancel(0)
        }
    }
}