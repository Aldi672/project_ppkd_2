import 'package:flutter/material.dart';

class BacaAsbabunNuzulScreen extends StatelessWidget {
  final String title = "Asbabun Nuzul";
  final String category = "Ilmu Al Quran";

  final String content = """
Al-Qur'an dalam proses penurunannya tidak turun sekaligus dalam satu waktu, 
namun turun secara berangsur-angsur dalam kurun waktu 23 tahun. Ada ayat yang 
turun untuk memberi hidayah, pendidikan, dan pencerahan tanpa didahului atau 
terkait dengan sebab tertentu dan ada juga yang turun karena adanya peristiwa 
atau pertanyaan yang membutuhkan penjelasan.

Latar belakang turunnya ayat atau yang biasa disebut sebagai Asbabun Nuzul 
merupakan ilmu yang penting untuk memahami konteks dan maksud dari suatu ayat. 
Dengan mengetahui sebab turunnya ayat, kita dapat lebih tepat dalam menafsirkan 
dan mengaplikasikan ajaran Al-Quran dalam kehidupan sehari-hari.

Ilmu Asbabun Nuzul membantu kita memahami:
1. Konteks historis turunnya ayat
2. Situasi dan kondisi masyarakat saat ayat turun
3. Hikmah di balik pensyariatan hukum
4. Rahasia pengulangan cerita dalam Al-Quran

Dengan demikian, pemahaman terhadap Asbabun Nuzul merupakan bagian penting 
dalam mempelajari dan mengamalkan ajaran Al-Quran secara komprehensif.
""";

  const BacaAsbabunNuzulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membaca'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.green[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header dengan latar belakang hijau
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category,
                    style: TextStyle(fontSize: 16, color: Colors.green[100]),
                  ),
                ],
              ),
            ),

            // Tombol mulai membaca
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Mulai membaca',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            // Konten bacaan
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 16, height: 1.6),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
