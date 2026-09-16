import 'package:cloud_firestore/cloud_firestore.dart';

class Kegiatan {
  final String id;
  final String namaKegiatan;
  final String deskripsi;
  final DateTime tanggalPelaksanaan;
  final String lokasi;

  Kegiatan({
    required this.id,
    required this.namaKegiatan,
    required this.deskripsi,
    required this.tanggalPelaksanaan,
    required this.lokasi,
  });

  factory Kegiatan.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Kegiatan(
      id: doc.id,
      namaKegiatan: data['nama_kegiatan'] ?? 'Tanpa Nama',
      deskripsi: data['deskripsi'] ?? '',
      tanggalPelaksanaan: (data['tanggal_pelaksanaan'] as Timestamp).toDate(),
      lokasi: data['lokasi'] ?? '',
    );
  }
}
