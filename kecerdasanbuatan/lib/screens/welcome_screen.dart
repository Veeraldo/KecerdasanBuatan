import 'package:flutter/material.dart';
import 'package:kecerdasanbuatan/screens/Diagnosis_Screen.dart';
import 'package:kecerdasanbuatan/screens/Penyakit_Screen.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.medical_services,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Diagnosa Penyakit THT',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50)
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
             ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF4A90E2),
    padding: const EdgeInsets.symmetric(
      horizontal: 32, 
      vertical: 16
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  onPressed: () {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const PenyakitScreen()
      ), 
      (Route<dynamic> route) => false,
    );
  },
  child: const Text(
    'Mulai Diagnosa',
    style: TextStyle(
      color: Color(0xFF2C3E50), 
      fontSize: 18, 
      fontWeight: FontWeight.bold,
    ),
  ),
)


            ],
          ),
        ),
      ),
    );
  }
}
