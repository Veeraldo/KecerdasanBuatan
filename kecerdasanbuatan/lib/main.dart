import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kecerdasanbuatan/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Memastikan binding widget terinisialisasi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Menggunakan FirebaseOptions sesuai platform
  );
  runApp(
      SistemPakarTHT()); // Menjalankan aplikasi setelah Firebase diinisialisasi
}

class SistemPakarTHT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Pakar THT',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:
          const HomeScreen(), // Mengarahkan ke HomeScreen setelah aplikasi berjalan
    );
  }
}
