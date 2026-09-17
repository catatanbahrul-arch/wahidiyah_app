import 'package:flutter/material.dart';
// Kita nyalakan kembali kedua file ini
import '../models/pengumuman_model.dart';
import '../services/firebase_service.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Memanggil layanan Firebase yang tadi kita perbaiki
    final firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Wahidiyah', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      // StreamBuilder bertugas sebagai "Pipa" yang mengalirkan data dari Firebase ke Layar
      body: StreamBuilder<List<Pengumuman>>(
        stream: firebaseService.getPengumumanStream(),
        builder: (context, snapshot) {
          // 1. Jika masih loading (mengambil data dari internet)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }
          
          // 2. Jika terjadi error di database
          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan:\n${snapshot.error}', textAlign: TextAlign.center),
            );
          }
          
          // 3. Jika datanya kosong / belum ada pengumuman
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Belum ada pengumuman saat ini.', style: TextStyle(fontSize: 16)),
            );
          }

          // 4. Jika datanya berhasil diambil!
          final listPengumuman = snapshot.data!;
          
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: listPengumuman.length,
            itemBuilder: (context, index) {
              // Menampilkan data dalam bentuk Kartu (Card)
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.campaign, color: Colors.green, size: 32),
                  title: Text(
                    'Pengumuman ${index + 1}', // Nanti ini bisa diganti dengan pengumuman.judul
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Detail pengumuman berhasil ditarik dari Firebase!'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
