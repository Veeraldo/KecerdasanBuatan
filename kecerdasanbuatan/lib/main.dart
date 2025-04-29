import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kecerdasanbuatan/screens/home_screen.dart';
import 'firebase_options.dart';

<<<<<<< HEAD
void main() {
  runApp(SistemPakarTHT());
}

class SistemPakarTHT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Pakar THT',
      theme: ThemeData(primarySwatch: Colors.blue),
=======
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <- WAJIB
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THT Checker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
>>>>>>> ec7d69aeaec8205c3f8bbdd83271267eceafb85c
    );
  }
}      

