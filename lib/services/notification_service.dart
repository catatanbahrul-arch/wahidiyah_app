import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Inisialisasi Zona Waktu (Default WIB)
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // Inisialisasi Ikon Notifikasi (menggunakan ikon bawaan flutter)
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const InitializationSettings initializationSettings = 
        InitializationSettings(android: initializationSettingsAndroid);
        
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Fungsi Alarm Dana Box (Pagi & Sore)
  Future<void> scheduleDailyDanaBox() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = 
        AndroidNotificationDetails(
            'dana_box_channel', 
            'Dana Box Reminder',
            channelDescription: 'Pengingat rutin Dana Box',
            importance: Importance.max,
            priority: Priority.high,
        );
        
    const NotificationDetails platformChannelSpecifics = 
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Jadwal Pagi (Jam 06:00)
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Pengingat Dana Box Pagi 🌞',
        'Sudahkah Anda berdana Box pagi ini?',
        _nextInstanceOfTime(6, 0),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);

    // Jadwal Sore (Jam 16:00)
    await flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        'Pengingat Dana Box Sore 🌇',
        'Sudahkah Anda berdana Box sore ini?',
        _nextInstanceOfTime(16, 0),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  // Rumus untuk menghitung waktu alarm berikutnya
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
