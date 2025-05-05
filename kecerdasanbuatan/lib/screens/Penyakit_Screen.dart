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
        title: const Text("🩺 Gejala Terkait"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: gejalaTeks.map((g) => Text("• $g")).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
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
        title: const Text("Daftar Penyakit"),
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
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
                  color: const Color(0xFF4A90E2),
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.visibility, color: Colors.white),
                    onTap: () => showGejalaDialog(gejalaIds),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _confirmSelection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Kembali ke Diagnosis',
                  style: TextStyle(fontSize: 18, color: Color(0xFF2C3E50)),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart_outlined, color: Color(0xFF2C3E50)),
            label: 'Penyakit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information_outlined,
                color: Color(0xFF2C3E50)),
            label: 'Diagnosis',
          ),
        ],
        currentIndex: 0,
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
