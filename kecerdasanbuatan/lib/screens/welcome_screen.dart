import 'package:flutter/material.dart';
import 'package:kecerdasanbuatan/screens/Diagnosis_Screen.dart';
import 'package:kecerdasanbuatan/screens/Penyakit_Screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), // Light green background for a fresh feel
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0), // Adjusted padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              const Icon(
                Icons.local_hospital_rounded,
                size: 120,
                color: Color(0xFF4CAF50), 
              ),
              const SizedBox(height: 40), 
              const Text(
                "Sakit ya?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C), 
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PenyakitScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios, size: 20),
                  label: const Text(
                    "Mulai Diagnosis",
                    style: TextStyle(
                      fontSize: 18, // Slightly larger text on the button
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), // Green color for the button
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5, // Slight elevation for the button to stand out
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
