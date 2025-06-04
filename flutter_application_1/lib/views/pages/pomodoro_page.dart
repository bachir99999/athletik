import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/widgets/pomodoro_widget.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chrono Page'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [PomodoroWidget()],
          ),
        ),
      ),
    );
  }
}
