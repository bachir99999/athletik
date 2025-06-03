import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page'), centerTitle: true),
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
                  // Action pour le bouton "Running"
                },
                child: const Text('Running'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // coins carrés
                  ),
                  side: const BorderSide(
                    width: 2,
                    color: Colors.white,
                  ), // Bordure blanche
                  foregroundColor: Colors.white, // Texte blanc
                ),
                onPressed: () {
                  // Action pour le bouton "Rounds"
                },
                child: const Text('Rounds'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
