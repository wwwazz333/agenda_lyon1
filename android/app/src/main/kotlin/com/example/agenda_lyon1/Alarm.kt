package com.example.agenda_lyon1

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.VibrationEffect
import android.provider.Settings
import android.util.Log
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class Alarm : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.getIntExtra("action", NONE)) {
            START -> {
                Log.d("AlarmAction", "START")
                val enabled = true
                if (enabled) {
                    //Sound
                    initMusicRingtone(context)
                    startRingtone(context)

                    //Vibration
                    startVibration(context)

                    //Notification
                    showNotification(context)

                    //affiche activity to disable alarm
                    val activityAlarm = Intent(context, AlarmRingActivity::class.java)
                    activityAlarm.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    context.startActivity(activityAlarm)
                    Log.d("Alarm", "ringing...")
                } else {
                    Log.d("Alarm", "alarm n'a pas pu sonner car elle est désactiver")
                }
            }

            STOP -> {
                Log.d("AlarmAction", "STOP")
                stopRingtone()
                stopVibration(context)
                clearNotif(context)
            }
            CANCEL_SNOOZE -> {
                intent.getStringExtra("idAlarm")?.let { id ->
                    Log.d("AlarmAction", "CANCEL_SNOOZE for id : $id")
                    Notif.cancelAlarmNotif(context)
                }
            }

            else -> Log.d("Alarm", "no action")
        }
    }


    private fun clearNotif(context: Context) {
        Notif.cancelAlarmNotif(context)
    }

    private fun showNotification(context: Context) {
        val ai = Intent(context, AlarmRingActivity::class.java)
        val cancelAlarmIntent = PendingIntent.getActivity(
            context,
            0,
            ai,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val notif = Notif(
            context, Notif.ALARM_NOTIFICATION_ID,
            "Alarm", "ring", R.drawable.ic_alarm, cancelAlarmIntent
        )
        notif.setOngoing(true)
        notif.setAutoCancel(false)

        notif.show()
    }

    private fun initMusicRingtone(context: Context) {
        ringtoneMusic = getUriRingtone(context)
    }

    private fun startRingtone(context: Context) {
        ring = RingtoneManager.getRingtone(context, ringtoneMusic)
        val alarmVolume = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ALARM)
                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                .build()
        } else {
            TODO("VERSION.SDK_INT < LOLLIPOP")
        }
        ring?.apply {
            audioAttributes = alarmVolume
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                isLooping = true
                play()
            } else {
                GlobalScope.launch {
                    while (ring != null) {
                        if (!isPlaying) {
                            play()
                        }
                        delay(500)
                    }
                }
                Log.d("Alarm", "can't put loop")
            }

        }
    }

    private fun stopRingtone() {
        ring?.stop()
        ring = null
    }

    private fun startVibration(context: Context) {
        val vibrator = VibratorSimpleUse.getVibrator(context)
        vibrator.cancel()
        val pattern = longArrayOf(1000, 1000, 1000, 1000)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createWaveform(pattern, 1))
        }
    }

    private fun stopVibration(context: Context) {
        VibratorSimpleUse.getVibrator(context).cancel()
    }

    companion object {
        const val NONE = 0
        const val STOP = 1
        const val START = 2
        const val CANCEL_SNOOZE = 3
        const val RINGTONE_ALARM = "ringtone_alarm"
        private var ringtoneMusic = Settings.System.DEFAULT_ALARM_ALERT_URI
        private var ring: Ringtone? = null

        fun getUriRingtone(context: Context): Uri {
            return Settings.System.DEFAULT_ALARM_ALERT_URI
        }

        /**
         * Cancel l'alarme précédente et en place une nouvelle
         *
         * @param context le context
         * @param time    heure de l'alarme (en ms)
         * @param id      id de l'alarme pour pouvoir la manipuler plus tard
         */
        fun setAlarm(context: Context, time: Long, id: String, howToLaunch: Int) {
            val ai = Intent(context, Alarm::class.java)
            ai.putExtra("action", howToLaunch)
            ai.data = Uri.parse("alarmClock://$id")
            ai.action = id
            val alarmIntent = PendingIntent.getBroadcast(
                context,
                0,
                ai,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            (context.getSystemService(Context.ALARM_SERVICE) as AlarmManager).apply {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    setAlarmClock(AlarmManager.AlarmClockInfo(time, alarmIntent), alarmIntent)
                }
            }
        }

        fun cancelAlarm(context: Context, id: String) {
            val ai = Intent(context, Alarm::class.java)
            ai.putExtra("action", START)
            ai.data = Uri.parse("alarmClock://$id")
            ai.action = id
            val alarmIntent = PendingIntent.getBroadcast(
                context,
                0,
                ai,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            (context.getSystemService(Context.ALARM_SERVICE) as AlarmManager).apply {
                cancel(alarmIntent)
            }
        }
    }
}