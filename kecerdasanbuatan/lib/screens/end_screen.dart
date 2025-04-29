import 'package:flutter/material.dart';
import 'package:kecerdasanbuatan/screens/welcome_screen.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({Key? key}) : super(key: key);

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
                Icons.check_circle,
                size: 100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              const Text(
                'Terima Kasih!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'Sudah melakukan diagnosa dengan aplikasi kami.\nSegera konsultasikan ke dokter jika diperlukan!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 194, 165, 244),
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
                      builder: (context) => const WelcomeScreen()
                    ),
                    (Route<dynamic> route) => false
                  ); 
                },
                child: const Text('Kembali ke Menu Utama'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
