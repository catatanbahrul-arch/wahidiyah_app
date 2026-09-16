import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pengumuman_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Pengumuman>> getPengumumanStream() {
    return _db
        .collection('pengumuman')
        .where('status_tampil', isEqualTo: true)
        .orderBy('tanggal_posting', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Pengumuman.fromFirestore(doc))
            .toList());
  }
}
