import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _gejalaList = [];
  List<Map<String, dynamic>> _penyakitList = [];
  List<String> _selectedGejala = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGejalaAndPenyakit();
  }

  // Fungsi untuk mengambil data gejala dan penyakit
  Future<void> fetchGejalaAndPenyakit() async {
    try {
      // Ambil data gejala
      final gejalaSnapshot = await FirebaseDatabase.instance.ref('gejala').get();
      final Map<dynamic, dynamic> gejalaDataMap = gejalaSnapshot.value as Map<dynamic, dynamic>;

      // Convert the LinkedMap to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> gejalaData = gejalaDataMap.entries.map((entry) {
        return Map<String, dynamic>.from(entry.value);
      }).toList();

      // Ambil data penyakit
      final penyakitSnapshot = await FirebaseDatabase.instance.ref('penyakit').get();
      final Map<dynamic, dynamic> penyakitDataMap = penyakitSnapshot.value as Map<dynamic, dynamic>;

      // Convert the LinkedMap to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> penyakitData = penyakitDataMap.entries.map((entry) {
        return Map<String, dynamic>.from(entry.value);
      }).toList();

      setState(() {
        _gejalaList = gejalaData;
        _penyakitList = penyakitData;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
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
      appBar: AppBar(
        title: Text('Diagnosa Penyakit THT'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _gejalaList.map((gejala) {
                return CheckboxListTile(
                  title: Text(gejala['gejala_penyakit'] ?? 'Gejala tidak diketahui'),
                  value: _selectedGejala.contains(gejala['no'].toString()),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedGejala.add(gejala['no'].toString());
                      } else {
                        _selectedGejala.remove(gejala['no'].toString());
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _confirmSelection,
              child: const Text('Konfirmasi Gejala'),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk konfirmasi pemilihan gejala dan menampilkan hasil
  void _confirmSelection() {
    List<String> matchedPenyakit = [];
    for (var penyakit in _penyakitList) {
      List<String> gejalaPenyakit = List<String>.from(penyakit['gejala_penyakit']);
      if (_selectedGejala.every((gejalaId) => gejalaPenyakit.contains("gejala_$gejalaId"))) {
        matchedPenyakit.add(penyakit['nama_penyakit']);
      }
    }

    if (matchedPenyakit.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Hasil Diagnosa"),
          content: const Text("Tidak ditemukan penyakit yang cocok."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Hasil Diagnosa"),
          content: Text("Penyakit yang cocok:\n\n${matchedPenyakit.join('\n')}"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
        ),
      );
    }
  }
}
