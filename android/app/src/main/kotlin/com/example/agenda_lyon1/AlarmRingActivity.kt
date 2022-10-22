package com.example.agenda_lyon1

import android.animation.ObjectAnimator
import android.animation.PropertyValuesHolder
import android.animation.ValueAnimator
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.ImageButton
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.iutcalendar.calendrier.CurrentDate
import com.iutcalendar.data.DataGlobal
import com.iutcalendar.notification.Notif
import com.iutcalendar.notification.NotificationChannels
import com.iutcalendar.settings.SettingsApp
import com.univlyon1.tools.agenda.R
import java.util.*
import kotlin.concurrent.schedule

class AlarmRingActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        //wakeup phone & not unlock needed
        wakeAndShowActivity()
        supportActionBar?.hide()

        setContentView(R.layout.activity_alarm_ring)
        val horaire: TextView = findViewById(R.id.horaire)
        val stopAlarmBtn: ImageButton = findViewById(R.id.stop_alarm_btn)
        horaire.text = CurrentDate().timeToString()
        setAnimAlarmBtn()
        stopAlarmBtn.setOnClickListener {
            stopAlarm()
        }


        findViewById<Button>(R.id.snoozeBtn)?.setOnClickListener { snooze() }

    }

    private fun setAnimAlarmBtn() {
        //Animation Button arrêt Alarm
        val scaleDown = ObjectAnimator.ofPropertyValuesHolder(
            findViewById<View>(R.id.shadow_btn),
            PropertyValuesHolder.ofFloat("scaleX", 3f),
            PropertyValuesHolder.ofFloat("scaleY", 3f)
        )
        scaleDown.duration = 500
        scaleDown.repeatMode = ValueAnimator.REVERSE
        scaleDown.repeatCount = ValueAnimator.INFINITE
        scaleDown.start()
    }

    private fun wakeAndShowActivity() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED)
            window.addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
        }
    }

    private fun stopAlarm() {
        val cancelAlarmIntent = Intent(applicationContext, Alarm::class.java)
        cancelAlarmIntent.putExtra("action", Alarm.STOP)
        sendBroadcast(cancelAlarmIntent)
        finish()
    }

    private fun snooze() {
        stopAlarm()


        val alarmSnoozed = AlarmRing(System.currentTimeMillis() + 5 * 60_000)
        PersonalAlarmManager.getInstance(applicationContext)
            .addNewAlarm(applicationContext, CurrentDate(), alarmSnoozed)

        Toast.makeText(applicationContext, getString(R.string.alarm_reported), Toast.LENGTH_LONG).show()

        Timer("snooze", true).schedule(1_500) { // schedule pour ne pas clear notif snooze
            Notif(
                applicationContext, NotificationChannels.ALARM_NOTIFICATION_ID, getString(R.string.snooze), getString(R.string.alarm_reported),
                R.drawable.ic_alarm, null
            ).apply {
                setOngoing(true)
                setAutoCancel(false)
                val cancelSnoozedAlarm = Intent(applicationContext, Alarm::class.java)
                cancelSnoozedAlarm.putExtra("action", Alarm.CANCEL_SNOOZE)
                cancelSnoozedAlarm.putExtra("idAlarm", alarmSnoozed.createAlarmId())

                addAction(
                    0,
                    getString(R.string.cancel),
                    PendingIntent.getBroadcast(
                        applicationContext,
                        0,
                        cancelSnoozedAlarm,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                )
                show()
            }
        }
    }
}