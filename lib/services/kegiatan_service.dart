import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kegiatan_model.dart';

class KegiatanService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Kegiatan>> getKegiatanStream() {
    return _db
        .collection('jadwal_kegiatan')
        .where('status_aktif', isEqualTo: true)
        .orderBy('tanggal_pelaksanaan', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Kegiatan.fromFirestore(doc))
            .toList());
  }
}
