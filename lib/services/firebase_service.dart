// import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pengumuman_model.dart';

class FirebaseService {
  // KITA MATIKAN MESIN FIREBASE SEMENTARA
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Pengumuman>> getPengumumanStream() {
    // Mengembalikan daftar kosong secara instan tanpa butuh koneksi Firebase
    return Stream.value([]);
  }
}
