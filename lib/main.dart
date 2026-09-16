import 'package:flutter/material.dart';
import 'screens/beranda_screen.dart';
import 'screens/kalender_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

// Widget Navigator untuk mengatur pindah-pindah layar
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;
  
  // Daftar layar yang bisa dibuka
  final List<Widget> _screens = [
    const BerandaScreen(),
    const KalenderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Kalender'),
        ],
      ),
    );
  }
}
