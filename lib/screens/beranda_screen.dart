import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/pengumuman_model.dart';
// import '../services/firebase_service.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Wahidiyah', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Menunggu Koneksi Firebase...'),
      )
    );
  }
}
