import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kecerdasanbuatan/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
<<<<<<< HEAD
  WidgetsFlutterBinding
      .ensureInitialized(); // Memastikan binding widget terinisialisasi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Menggunakan FirebaseOptions sesuai platform
  );
  runApp(
      SistemPakarTHT()); // Menjalankan aplikasi setelah Firebase diinisialisasi
=======
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan binding widget terinisialisasi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Menggunakan FirebaseOptions sesuai platform
  );
  runApp(SistemPakarTHT()); // Menjalankan aplikasi setelah Firebase diinisialisasi
>>>>>>> 69a352c4548c5281a47b74ca5e788c1ccf3674d5
}

class SistemPakarTHT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Pakar THT',
      theme: ThemeData(primarySwatch: Colors.blue),
<<<<<<< HEAD
      home:
          const HomeScreen(), // Mengarahkan ke HomeScreen setelah aplikasi berjalan
=======
      home: const HomeScreen(), // Mengarahkan ke HomeScreen setelah aplikasi berjalan
>>>>>>> 69a352c4548c5281a47b74ca5e788c1ccf3674d5
    );
  }
}
