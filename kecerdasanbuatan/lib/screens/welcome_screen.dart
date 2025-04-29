import 'package:flutter/material.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.medical_services,
                size: 100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              const Text(
                'Diagnosa Penyakit THT',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 206, 182, 249),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32, 
                    vertical: 16
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen()
                    ), 
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Mulai Diagnosa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
