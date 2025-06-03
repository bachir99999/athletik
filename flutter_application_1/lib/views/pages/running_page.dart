import 'package:flutter/material.dart';

class RunningPage extends StatelessWidget {
  const RunningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Running Page'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  side: const BorderSide(
                    width: 2,
                    color: Colors.white,
                  ), // Bordure blanche
                  foregroundColor: Colors.white, // Texte blanc
                ),
                onPressed: () {
                  // Action pour le bouton "Start Running"
                },
                child: const Text('Start Running'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
