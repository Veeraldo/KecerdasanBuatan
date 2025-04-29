import 'package:firebase_database/firebase_database.dart';

class THTServices {
  final DatabaseReference _penyakitDatabase = FirebaseDatabase.instance.ref().child('penyakit');
  final DatabaseReference gejalaDatabase = FirebaseDatabase.instance.ref().child('gejala');


  Future<List<String>> findPenyakitByGejala(List<String> selectedGejala) async {
    final snapshot = await _penyakitDatabase.get();

    List<String> matchingPenyakit = [];

    if (snapshot.exists) {
      final Map<String, dynamic> penyakitData = Map<String, dynamic>.from(snapshot.value as Map);

      penyakitData.forEach((key, value) {
        if (value is Map && value['gejala_penyakit'] is List) {
          List<dynamic> gejalaList = value['gejala_penyakit'];
          bool isMatch = selectedGejala.every((gejala) => gejalaList.contains(gejala));

          if (isMatch) {
            matchingPenyakit.add(value['nama_penyakit'] ?? 'Unknown');
          }
        }
      });
    }

    return matchingPenyakit;
  }
}
