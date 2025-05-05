import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kecerdasanbuatan/screens/Penyakit_Screen.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({Key? key}) : super(key: key);

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}
class _DiagnosisScreenState extends State<DiagnosisScreen> {
  List<Map<String, dynamic>> _gejalaList = [];
  List<Map<String, dynamic>> _penyakitList = [];
  List<String> _selectedGejala = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGejalaAndPenyakit();
  }

  Future<void> fetchGejalaAndPenyakit() async {
    try {
      final gejalaSnapshot =
          await FirebaseDatabase.instance.ref('gejala').get();
      final penyakitSnapshot =
          await FirebaseDatabase.instance.ref('penyakit').get();

      if (gejalaSnapshot.value is Map) {
        final Map<dynamic, dynamic> gejalaMap =
            gejalaSnapshot.value as Map<dynamic, dynamic>;
        _gejalaList = gejalaMap.entries.map((entry) {
          final data = Map<String, dynamic>.from(entry.value);
          return data;
        }).toList()
          ..sort((a, b) => a['no'].compareTo(b['no']));
      }

      if (penyakitSnapshot.value is Map) {
        final Map<dynamic, dynamic> penyakitMap =
            penyakitSnapshot.value as Map<dynamic, dynamic>;
        _penyakitList = penyakitMap.entries.map((entry) {
          final data = Map<String, dynamic>.from(entry.value);
          return data;
        }).toList();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error saat ambil data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _confirmSelection() {
    final List<String> matchedPenyakit = [];
    final List<List<String>> matchedGejala = [];

    for (var penyakit in _penyakitList) {
      final raw = penyakit['gejala_penyakit'];
      List<String> gejalaIds = [];

      if (raw is Map) {
        gejalaIds = raw.values.map((e) => e.toString()).toList();
      } else if (raw is List) {
        gejalaIds = raw.map((e) => e.toString()).toList();
      }

      final selectedFull = _selectedGejala.map((id) => 'gejala_$id');

      if (selectedFull.every((id) => gejalaIds.contains(id))) {
        matchedPenyakit.add(penyakit['nama_penyakit']);

        final names = gejalaIds.map((gid) {
          final g = _gejalaList.firstWhere(
            (item) => 'gejala_${item['no']}' == gid,
            orElse: () => {},
          );
          return g.isNotEmpty ? g['gejala_penyakit'] as String : gid;
        }).toList();

        matchedGejala.add(names);
      }
    }

    if (matchedPenyakit.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Hasil Diagnosa',
              style: TextStyle(color: Color(0xFF2C3E50))),
          content: const Text('Tidak ditemukan penyakit yang cocok.',
              style: TextStyle(color: Color(0xFF2C3E50))),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK',
                  style: TextStyle(color: Color(0xFF4A90E2))),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Hasil Diagnosa',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF2C3E50)),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < matchedPenyakit.length; i++) ...[
                  Text(
                    '🦠 ${matchedPenyakit[i]}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '📋 Gejala terkait:',
                    style: TextStyle(color: Color(0xFF2C3E50)),
                  ),
                  ...matchedGejala[i].map(
                    (g) => Text(
                      '• $g',
                      style: const TextStyle(color: Color(0xFF2C3E50)),
                    ),
                  ),
                  if (i < matchedPenyakit.length - 1) const Divider(),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Apa Gejala yang Anda Alami?',
          style: TextStyle(color: Color(0xFF2C3E50)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
      ),
      body: Container(
        color: const Color(0xFFFAFAFA),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _gejalaList.length,
                itemBuilder: (context, index) {
                  final gejala = _gejalaList[index];
                  final no = gejala['no'].toString();
                  final text =
                      gejala['gejala_penyakit'] ?? 'Gejala tidak diketahui';
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    color: const Color(0xFF4A90E2), 
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white,
                        ),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text(
                            'Gejala $no: $text',
                            style: const TextStyle(
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          value: _selectedGejala.contains(no),
                          activeColor: Colors.white,
                          checkColor: const Color(0xFF4A90E2),
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                _selectedGejala.add(no);
                              } else {
                                _selectedGejala.remove(no);
                              }
                            });
                          },
                        ),
                      ),
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
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Konfirmasi Gejala',
                      style: TextStyle(fontSize: 18, color: Color(0xFF2C3E50))),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart_outlined, color: Color(0xFF2C3E50)),
            label: 'Penyakit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information_outlined, color: Color(0xFF2C3E50)),
            label: 'Diagnosis',
          ),
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PenyakitScreen()),
            );
          }
        },
      ),
    );
  }
}
