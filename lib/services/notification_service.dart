import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/kegiatan_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // 1. Alarm Dana Box Pagi & Sore (Offline)
  Future<void> scheduleDailyDanaBox() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = 
        AndroidNotificationDetails('dana_box', 'Dana Box', importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        1, 'Pengingat Dana Box Pagi 🌞', 'Sudahkah Anda berdana Box pagi ini?',
        _nextInstanceOfTime(6, 0), platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        2, 'Pengingat Dana Box Sore 🌇', 'Sudahkah Anda berdana Box sore ini?',
        _nextInstanceOfTime(16, 0), platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // 2. Alarm H-7 Kegiatan (Dicuplik dari Firebase, diputar Offline)
  Future<void> scheduleEventReminders(List<Kegiatan> kegiatans) async {
    int notificationId = 100; // Mulai dari ID 100 agar tidak bentrok dengan Dana Box
    const AndroidNotificationDetails androidPlatformChannelSpecifics = 
        AndroidNotificationDetails('kegiatan', 'Kegiatan Wahidiyah', importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    for (var kegiatan in kegiatans) {
      final DateTime eventDate = kegiatan.tanggalPelaksanaan;
      final tz.TZDateTime tzEventDate = tz.TZDateTime.from(eventDate, tz.local);
      
      // Rumus H-7 pada pukul 07:00 Pagi
      final tz.TZDateTime hMinus7 = tzEventDate.subtract(const Duration(days: 7));
      final tz.TZDateTime reminderTime = tz.TZDateTime(tz.local, hMinus7.year, hMinus7.month, hMinus7.day, 7, 0);

      // Hanya jadwalkan alarm jika waktu H-7 belum terlewat
      if (reminderTime.isAfter(tz.TZDateTime.now(tz.local))) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId++, 
            'H-7: ${kegiatan.namaKegiatan}', 
            'Siapkan diri Anda untuk kegiatan pada ${eventDate.day}/${eventDate.month}/${eventDate.year} di ${kegiatan.lokasi}',
            reminderTime, 
            platformChannelSpecifics,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
      }
    }
  }
}
