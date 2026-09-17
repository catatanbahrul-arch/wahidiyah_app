import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pengumuman_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Pengumuman>> getPengumumanStream() {
    // Kita hapus sementara fitur filter (.where) dan urutkan (.orderBy)
    // agar Firebase tidak meminta "Composite Index"
    return _db
        .collection('pengumuman')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Pengumuman.fromFirestore(doc))
            .toList());
  }
}
