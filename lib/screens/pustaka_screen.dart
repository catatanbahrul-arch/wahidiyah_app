import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/buku_model.dart';
import '../services/pustaka_service.dart';

class PustakaScreen extends StatelessWidget {
  const PustakaScreen({super.key});

  // Fungsi untuk membuka link PDF / Web
  Future<void> _bukaFile(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Gagal membuka link: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pustakaService = PustakaService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pustaka Wahidiyah', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Buku>>(
        stream: pustakaService.getBukuStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat pustaka.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada buku/kitab.'));
          }

          final listBuku = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 buku berjejer
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65, // Rasio panjang x lebar ala buku
            ),
            itemCount: listBuku.length,
            itemBuilder: (context, index) {
              final buku = listBuku[index];
              return InkWell(
                onTap: () {
                  if (buku.fileUrl.isNotEmpty) {
                    _bukaFile(buku.fileUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link file belum tersedia')),
                    );
                  }
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Area Cover Buku
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          child: buku.coverUrl != null && buku.coverUrl!.isNotEmpty
                              ? Image.network(buku.coverUrl!, fit: BoxFit.cover)
                              : Container(
                                  color: Colors.green.shade100,
                                  child: const Icon(Icons.book, size: 50, color: Colors.green),
                                ),
                        ),
                      ),
                      // Area Judul
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              buku.judul, 
                              maxLines: 2, 
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              buku.penulis,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
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
