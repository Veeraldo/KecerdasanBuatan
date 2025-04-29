import 'package:flutter/material.dart';
import 'package:kecerdasanbuatan/services/THT_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final THTServices _thtServices = THTServices();

  Map<String, String> _allGejala = {}; // key: gejala_x, value: nama gejala
  List<String> _selectedGejala = []; // Yang dipilih user
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGejala();
  }

  Future<void> fetchGejala() async {
    final gejalaSnapshot = await _thtServices.gejalaDatabase.get();
    if (gejalaSnapshot.exists) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(gejalaSnapshot.value as Map);
      final Map<String, String> loadedGejala = {};
      data.forEach((key, value) {
        if (value is Map) {
          loadedGejala[key] = value['gejala_penyakit'] ?? '';
        }
      });
      setState(() {
        _allGejala = loadedGejala;
        _isLoading = false;
      });
    }
  }

  void _confirmSelection() async {
    final result = await _thtServices.findPenyakitByGejala(_selectedGejala);

    if (result.isEmpty) {
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
          content: Text("Penyakit yang cocok:\n\n${result.join('\n')}"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
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
      appBar: AppBar(
        title: const Text('Diagnosa Penyakit THT'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _allGejala.entries.map((entry) {
                return CheckboxListTile(
                  title: Text(entry.value),
                  value: _selectedGejala.contains(entry.key),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedGejala.add(entry.key);
                      } else {
                        _selectedGejala.remove(entry.key);
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
          )
        ],
      ),
    );
  }
}
