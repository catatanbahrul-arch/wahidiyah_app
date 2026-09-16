import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/kegiatan_model.dart';
import '../services/kegiatan_service.dart';
import '../services/notification_service.dart';

class KegiatanScreen extends StatelessWidget {
  const KegiatanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final kegiatanService = KegiatanService();
    final notificationService = NotificationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Kegiatan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Kegiatan>>(
        stream: kegiatanService.getKegiatanStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat jadwal kegiatan.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada jadwal kegiatan mendatang.'));
          }

          final listKegiatan = snapshot.data!;
          
          // Trik Cerdas: Sinkronisasi alarm H-7 secara diam-diam di balik layar
          notificationService.scheduleEventReminders(listKegiatan);

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: listKegiatan.length,
            itemBuilder: (context, index) {
              final item = listKegiatan[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(Icons.event_note, color: Colors.green, size: 40),
                  title: Text(item.namaKegiatan, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('📅 ${DateFormat('dd MMMM yyyy - HH:mm').format(item.tanggalPelaksanaan)}', style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text('📍 ${item.lokasi}', style: TextStyle(color: Colors.red.shade700)),
                      const SizedBox(height: 8),
                      Text(item.deskripsi, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
