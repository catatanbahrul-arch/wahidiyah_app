import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/beranda_screen.dart';
import 'screens/kalender_screen.dart';
import 'screens/kegiatan_screen.dart';
import 'screens/pustaka_screen.dart';
// import 'services/notification_service.dart'; // KITA MATIKAN SEMENTARA

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // MENYALAKAN FIREBASE
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // KITA MATIKAN FITUR NOTIFIKASI SEMENTARA UNTUK CEK ERROR
    // final notificationService = NotificationService();
    // await notificationService.init();
    // await notificationService.scheduleDailyDanaBox();

    runApp(const WahidiyahApp());
  } catch (error) {
    // JIKA ADA ERROR, JANGAN BLANK HITAM, TAMPILKAN TEKS MERAH DI LAYAR!
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'KETEMU ERROR-NYA:\n\n$error',
              style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ));
  }
}

// ... (KODE class WahidiyahApp dan MainNavigator DI BAWAHNYA BIARKAN SAMA PERSIS SEPERTI SEBELUMNYA) ...
