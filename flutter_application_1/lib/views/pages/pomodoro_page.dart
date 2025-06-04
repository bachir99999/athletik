import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/widgets/pomodoro_widget.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Page'), centerTitle: true),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/pomodoro_bg.jpg', fit: BoxFit.cover),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [PomodoroWidget()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
