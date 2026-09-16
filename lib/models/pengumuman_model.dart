import 'package:cloud_firestore/cloud_firestore.dart';

class Pengumuman {
  final String id;
  final String judul;
  final String isiPesan;
  final String? gambarUrl;
  final DateTime tanggalPosting;

  Pengumuman({
    required this.id,
    required this.judul,
    required this.isiPesan,
    this.gambarUrl,
    required this.tanggalPosting,
  });

  factory Pengumuman.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Pengumuman(
      id: doc.id,
      judul: data['judul'] ?? 'Tanpa Judul',
      isiPesan: data['isi_pesan'] ?? '',
      gambarUrl: data['gambar_url'],
      tanggalPosting: (data['tanggal_posting'] as Timestamp).toDate(),
    );
  }
}
