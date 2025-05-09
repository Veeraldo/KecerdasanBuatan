import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PenyakitDetailScreen extends StatefulWidget {
  final String penyakit;

  const PenyakitDetailScreen({Key? key, required this.penyakit}) : super(key: key);

  @override
  State<PenyakitDetailScreen> createState() => _PenyakitDetailScreenState();
}

class _PenyakitDetailScreenState extends State<PenyakitDetailScreen> {
  String _description = 'Mengambil deskripsi...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDescription();
  }

  Future<void> _fetchDescription() async {
    const apiKey = 'AIzaSyAbzEe9UgFSaDt8Y5lv83aOe-zOq1u0CTg'; // Ganti dengan API key dari Google AI Studio
    const apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    final prompt = '''
Buat penjelasan singkat dan mudah dipahami mengenai penyakit "${widget.penyakit}". 
Sertakan, gejala umum, penyebab utama, dan saran penanganan awal. 
Gunakan bahasa Indonesia yang lebih rapi dan akurat serta berikan jeda untuk setiap penjelasan. Fokus pada informasi yang berguna dan detail. tidak usah menampilkan kalimat tambahanmu cukup informasi saja, 
''';

    final body = jsonEncode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (text != null) {
          setState(() {
            _description = text;
            _isLoading = false;
          });
        } else {
          setState(() {
            _description = 'Deskripsi tidak tersedia.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _description = 'Gagal mendapatkan deskripsi (Status: ${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _description = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50), 
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          widget.penyakit,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: const Color(0xFFF1F8E9), // Light green background for the card
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Penyakit: ${widget.penyakit}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF388E3C), // Dark green for the title
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50), // Green color for the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                        ),
                        child: const Text(
                          'Kembali',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
