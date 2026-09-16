import 'package:cloud_firestore/cloud_firestore.dart';

class Buku {
  final String id;
  final String judul;
  final String penulis;
  final String? coverUrl;
  final String fileUrl; // Link PDF / Web
  
  Buku({
    required this.id,
    required this.judul,
    required this.penulis,
    this.coverUrl,
    required this.fileUrl,
  });

  factory Buku.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Buku(
      id: doc.id,
      judul: data['judul'] ?? 'Tanpa Judul',
      penulis: data['penulis'] ?? 'Pusat Wahidiyah',
      coverUrl: data['cover_url'],
      fileUrl: data['file_url'] ?? '',
    );
  }
}
