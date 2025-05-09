import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kecerdasanbuatan/screens/Diagnosis_Screen.dart';

class PenyakitScreen extends StatefulWidget {
  const PenyakitScreen({super.key});

  @override
  State<PenyakitScreen> createState() => _PenyakitScreenState();
}

class _PenyakitScreenState extends State<PenyakitScreen> {
  List<Map<String, dynamic>> _penyakitList = [];
  List<Map<String, dynamic>> _gejalaList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPenyakitDanGejala();
  }

  Future<void> fetchPenyakitDanGejala() async {
    try {
      final penyakitSnapshot =
          await FirebaseDatabase.instance.ref('penyakit').get();
      final gejalaSnapshot =
          await FirebaseDatabase.instance.ref('gejala').get();

      if (penyakitSnapshot.value is Map) {
        final Map<dynamic, dynamic> penyakitMap =
            penyakitSnapshot.value as Map<dynamic, dynamic>;
        _penyakitList = penyakitMap.entries.map((e) {
          return Map<String, dynamic>.from(e.value);
        }).toList();
      }

      if (gejalaSnapshot.value is Map) {
        final Map<dynamic, dynamic> gejalaMap =
            gejalaSnapshot.value as Map<dynamic, dynamic>;
        _gejalaList = gejalaMap.entries.map((e) {
          final data = Map<String, dynamic>.from(e.value);
          data['id'] = e.key;
          return data;
        }).toList();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showGejalaDialog(List<String> gejalaIds) {
  final List gejalaTeks = gejalaIds.map((gid) {
    final match = _gejalaList.where((g) => g['id'] == gid);
    return match.isNotEmpty ? match.first['gejala_penyakit'] : gid;
  }).toList();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFFF1F8E9),  
      title: const Text(
        "🩺 Gejala Terkait",
        style: TextStyle(
          color: Color(0xFF388E3C),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: gejalaTeks.map((g) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 18), // Ikon centang hijau
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    g,
                    style: const TextStyle(
                      color: Color(0xFF2C3E50),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
      ],
    ),
  );
}

  void _confirmSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DiagnosisScreen(penyakit: {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daftar Penyakit",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 4,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _penyakitList.length,
              itemBuilder: (context, index) {
                final penyakit = _penyakitList[index];
                final String nama = penyakit['nama_penyakit'] ?? 'Tanpa nama';
                List<String> gejalaIds = [];

                final raw = penyakit['gejala_penyakit'];
                if (raw is Map) {
                  gejalaIds = raw.values.map((e) => e.toString()).toList();
                } else if (raw is List) {
                  gejalaIds = raw.map((e) => e.toString()).toList();
                }

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF2C3E50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Klik untuk melihat gejala',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7D8C8D),
                      ),
                    ),
                    trailing: const Icon(Icons.visibility, color: const Color(0xFF4CAF50),),
                    onTap: () => showGejalaDialog(gejalaIds),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart_outlined, color: Colors.white),
            label: 'Penyakit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information_outlined,
                color: Colors.white),
            label: 'Diagnosis',
          ),
        ],
        currentIndex: 0,
        backgroundColor: const Color(0xFF4CAF50),
        selectedItemColor: Color(0xFFB0BEC5),
        unselectedItemColor: Color(0xFFB0BEC5),
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DiagnosisScreen(penyakit: {}),
              ),
            );
          }
        },
      ),
    );
  }
}
