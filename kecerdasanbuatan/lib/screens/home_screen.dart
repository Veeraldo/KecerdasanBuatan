import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kecerdasanbuatan/screens/end_screen.dart';

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

  Future<void> fetchGejalaAndPenyakit() async {
    try {
      //Ambil data 
      final gejalaSnapshot = await FirebaseDatabase.instance.ref('gejala').get();
      final penyakitSnapshot = await FirebaseDatabase.instance.ref('penyakit').get();

      List<Map<String, dynamic>> gejalaData = [];
      List<Map<String, dynamic>> penyakitData = [];

      if (gejalaSnapshot.value != null) {
        final Map<dynamic, dynamic> gejalaDataMap = gejalaSnapshot.value as Map<dynamic, dynamic>;
        gejalaData = gejalaDataMap.entries.map((entry) {
          return Map<String, dynamic>.from(entry.value);
        }).toList();
      }

      if (penyakitSnapshot.value != null) {
        final Map<dynamic, dynamic> penyakitDataMap = penyakitSnapshot.value as Map<dynamic, dynamic>;
        penyakitData = penyakitDataMap.entries.map((entry) {
          return Map<String, dynamic>.from(entry.value);
        }).toList();
      }

      setState(() {
        // Urutan gejala
        gejalaData.sort((a, b) => a['no'].compareTo(b['no']));
        
        _gejalaList = gejalaData;
        _penyakitList = penyakitData;
        _isLoading = false;
      });
    } catch (e) {
      print("Error data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Hasil Diagnosa",
            textAlign: TextAlign.center,
          ),
          content: Text("Penyakit yang cocok:\n\n${matchedPenyakit.join('\n')}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const ThankYouScreen(),
                  ),
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.deepPurple[100],
            strokeWidth: 5,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosa Penyakit THT'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 207, 180, 253),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0c3fc), Color(0xFF8ec5fc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _gejalaList.length,
                itemBuilder: (context, index) {
                  final gejala = _gejalaList[index];
                  final noGejala = gejala['no'].toString();
                  final namaGejala = gejala['gejala_penyakit'] ?? 'Gejala tidak diketahui';
        
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8, 
                      horizontal: 10
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, 
                        vertical: 8
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          'Gejala $noGejala: $namaGejala',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        value: _selectedGejala.contains(noGejala),
                        activeColor: Colors.deepPurple,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedGejala.add(noGejala);
                            } else {
                              _selectedGejala.remove(noGejala);
                            }
                          });
                        },
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                    elevation: 5,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  onPressed: _confirmSelection,
                  child: const Text('Konfirmasi Gejala'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
