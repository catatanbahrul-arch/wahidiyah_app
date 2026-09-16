import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/buku_model.dart';

class PustakaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Buku>> getBukuStream() {
    return _db
        .collection('pustaka')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Buku.fromFirestore(doc))
            .toList());
  }
}
