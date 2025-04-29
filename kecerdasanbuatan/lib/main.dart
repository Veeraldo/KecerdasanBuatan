import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kecerdasanbuatan/screens/home_screen.dart'; 
import 'firebase_options.dart'; 

void main() async {
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
<<<<<<< HEAD
      title: 'Diagnosa THT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeScreen(),
=======
      title: 'Sistem Pakar THT',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(), 
>>>>>>> 3121365b8e5def2f80a60ec957e925bf9e7f025a
    );
  }
}
