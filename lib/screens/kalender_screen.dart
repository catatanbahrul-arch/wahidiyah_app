import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:adhan/adhan.dart';

class KalenderScreen extends StatefulWidget {
  const KalenderScreen({super.key});

  @override
  State<KalenderScreen> createState() => _KalenderScreenState();
}

class _KalenderScreenState extends State<KalenderScreen> {
  final _today = HijriCalendar.now();
  PrayerTimes? _prayerTimes;

  @override
  void initState() {
    super.initState();
    _setupJadwalSholat();
  }

  void _setupJadwalSholat() {
    // Kordinat statis: Kediri, Jawa Timur (Pusat Wahidiyah)
    final myCoordinates = Coordinates(-7.8166, 112.0118); 
    
    // Parameter standar Kemenag RI / Asia Tenggara
    final params = CalculationMethod.singapore.getParameters();
    params.madhab = Madhab.shafi;
    
    _prayerTimes = PrayerTimes.today(myCoordinates, params);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender & Waktu Sholat', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartu Tanggal Hijriah
            Card(
              color: Colors.green.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                child: Column(
                  children: [
                    const Text('Tanggal Hijriah Hari Ini', style: TextStyle(fontSize: 16, color: Colors.black87)),
                    const SizedBox(height: 10),
                    Text(
                      '${_today.hDay} ${_today.longMonthName} ${_today.hYear} H',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            
            // Judul Jadwal Sholat
            const Text(
              'Jadwal Sholat (Kediri & Sekitarnya)', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            
            // List Waktu Sholat
            if (_prayerTimes != null) ...[
              _buildJadwalRow('Subuh', _prayerTimes!.fajr),
              _buildJadwalRow('Dzuhur', _prayerTimes!.dhuhr),
              _buildJadwalRow('Ashar', _prayerTimes!.asr),
              _buildJadwalRow('Maghrib', _prayerTimes!.maghrib),
              _buildJadwalRow('Isya', _prayerTimes!.isha),
            ] else 
              const Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }

  // Desain baris jam sholat
  Widget _buildJadwalRow(String nama, DateTime waktu) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(nama, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text(
              '${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
