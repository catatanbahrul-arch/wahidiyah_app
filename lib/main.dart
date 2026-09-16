import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/beranda_screen.dart';
import 'screens/kalender_screen.dart';
import 'screens/kegiatan_screen.dart';
import 'screens/pustaka_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // INI SAKLAR FIREBASE-NYA!
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.scheduleDailyDanaBox();

  runApp(const WahidiyahApp());
}

class WahidiyahApp extends StatelessWidget {
  const WahidiyahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jamaah Wahidiyah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainNavigator(),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;
  
  // 4 Layar Utama Aplikasi
  final List<Widget> _screens = [
    const BerandaScreen(),
    const KalenderScreen(),
    const KegiatanScreen(),
    const PustakaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Penting agar icon > 3 tidak berantakan
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Kalender'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Kegiatan'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Pustaka'),
        ],
      ),
    );
  }
}
