import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kecerdasanbuatan/screens/Penyakit_Screen.dart';
import 'package:kecerdasanbuatan/screens/penyakitdetail_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({Key? key, required Map penyakit}) : super(key: key);

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
    fetchGejalaDanPenyakit();
  }

  Future<void> fetchGejalaDanPenyakit() async {
    try {
      final gejalaSnapshot = await FirebaseDatabase.instance.ref('gejala').get();
      final penyakitSnapshot = await FirebaseDatabase.instance.ref('penyakit').get();

      if (gejalaSnapshot.value is Map) {
        final Map<dynamic, dynamic> gejalaMap = gejalaSnapshot.value as Map<dynamic, dynamic>;
        _gejalaList = gejalaMap.entries.map((e) {
          final data = Map<String, dynamic>.from(e.value);
          return data;
        }).toList()
          ..sort((a, b) => a['no'].compareTo(b['no']));
      }

      if (penyakitSnapshot.value is Map) {
        final Map<dynamic, dynamic> penyakitMap = penyakitSnapshot.value as Map<dynamic, dynamic>;
        _penyakitList = penyakitMap.entries.map((e) {
          final data = Map<String, dynamic>.from(e.value);
          return data;
        }).toList();
      }

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('Gagal ambil data: $e');
      setState(() => _isLoading = false);
    }
  }

  void _diagnosis() {
    final List<String> hasilPenyakit = [];
    final List<double> hasilPersen = [];

    for (var penyakit in _penyakitList) {
      List<String> gejalaPenyakit = [];

      final raw = penyakit['gejala_penyakit'];
      if (raw is Map) {
        gejalaPenyakit = raw.values.map((e) => e.toString()).toList();
      } else if (raw is List) {
        gejalaPenyakit = raw.map((e) => e.toString()).toList();
      }

      final selectedFull = _selectedGejala.map((id) => 'gejala_$id');
      final cocok = selectedFull.where((id) => gejalaPenyakit.contains(id)).toList();
      final persen = (cocok.length / gejalaPenyakit.length) * 100;

      if (cocok.isNotEmpty) {
        hasilPenyakit.add(penyakit['nama_penyakit']);
        hasilPersen.add(persen);
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hasil Diagnosis',
          textAlign: TextAlign.center,
          style: TextStyle(color: const Color(0xFF4CAF50), fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: hasilPenyakit.isEmpty
              ? const Text("Tidak ada kecocokan gejala dengan penyakit.")
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < hasilPenyakit.length; i++) ...[
                      Text(
                        '🦠 ${hasilPenyakit[i]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: const Color(0xFF4CAF50)
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kecocokan: ${hasilPersen[i].toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: hasilPersen[i] / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          hasilPersen[i] >= 70
                              ? Colors.green
                              : hasilPersen[i] >= 40
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '📋 Gejala terkait:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      ...() {
                        final raw = _penyakitList.firstWhere((p) => p['nama_penyakit'] == hasilPenyakit[i])['gejala_penyakit'];
                        List<String> gejalaIds = raw is Map
                            ? raw.values.map((e) => e.toString()).toList()
                            : raw is List
                                ? raw.map((e) => e.toString()).toList()
                                : [];

                        return gejalaIds.map((gid) {
                          final gejalaData = _gejalaList.firstWhere(
                            (g) => 'gejala_${g['no']}' == gid,
                            orElse: () => {},
                          );
                          final label = gejalaData.isNotEmpty ? gejalaData['gejala_penyakit'] : gid;
                          final isSelected = _selectedGejala.contains(gid.replaceAll('gejala_', ''));

                          return Row(
                            children: [
                              Icon(
                                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: isSelected ? Colors.green : Colors.grey,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    color: isSelected ? Colors.green[800] : const Color(0xFF4CAF50)
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      }(),
                      const SizedBox(height: 8),
                  
                      TextButton(
                        onPressed: () {
                       
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PenyakitDetailScreen(
                                penyakit: hasilPenyakit[i], 
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Pelajari Lebih Lanjut',
                          style: TextStyle(color: const Color(0xFF4CAF50)),
                        ),
                      ),
                      if (i < hasilPenyakit.length - 1) const Divider(height: 30),
                    ],
                  ],
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: const Color(0xFF4CAF50),)),
          ),
        ],
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
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Apa Gejala Anda?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _gejalaList.length,
              itemBuilder: (context, index) {
                final gejala = _gejalaList[index];
                final no = gejala['no'].toString();
                final label = gejala['gejala_penyakit'] ?? 'Tidak diketahui';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  color: Colors.white,
                  child: CheckboxListTile(
                    title: Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.w500, color: const Color(0xFF4CAF50),),
                    ),
                    value: _selectedGejala.contains(no),
                    activeColor: const Color(0xFF4CAF50),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedGejala.add(no);
                        } else {
                          _selectedGejala.remove(no);
                        }
                      });
                    },
              ),
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _diagnosis,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Diagnosis', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
      ),
    ],
  ),
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: 1,
    onTap: (index) {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PenyakitScreen()),
        );
      }
    },
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.monitor_heart_outlined, color: Colors.white),
        label: 'Penyakit',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.medical_information_outlined, color: Colors.white),
        label: 'Diagnosis',
      ),
    ],
    backgroundColor:  const Color(0xFF4CAF50),
    selectedItemColor: Color(0xFFB0BEC5),
    unselectedItemColor: Color(0xFFB0BEC5),
    type: BottomNavigationBarType.fixed,
  ),
);
  }
}