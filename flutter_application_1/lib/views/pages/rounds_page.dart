import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/widgets/rounds_widget.dart';

class RoundsPage extends StatelessWidget {
  const RoundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rounds Page'), centerTitle: true),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/rounds_bg.jpg', fit: BoxFit.cover),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [RoundsWidget()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
