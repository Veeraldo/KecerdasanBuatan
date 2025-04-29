import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kecerdasanbuatan/screens/home_screen.dart'; 
import 'firebase_options.dart'; 

void main() async {
<<<<<<< HEAD
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diagnosa THT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeScreen(),
=======
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan binding widget terinisialisasi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Menggunakan FirebaseOptions sesuai platform
  );
  runApp(SistemPakarTHT()); // Menjalankan aplikasi setelah Firebase diinisialisasi
}

class SistemPakarTHT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Pakar THT',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(), // Mengarahkan ke HomeScreen setelah aplikasi berjalan
>>>>>>> 69a352c4548c5281a47b74ca5e788c1ccf3674d5
    );
  }
}
