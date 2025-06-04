import 'package:flutter/material.dart';

class PomodoroWidget extends StatefulWidget {
  const PomodoroWidget({super.key});

  @override
  State<PomodoroWidget> createState() => _PomodoroWidgetState();
}

class _PomodoroWidgetState extends State<PomodoroWidget> {
  int workMinutes = 25;
  int restMinutes = 5;

  Duration get workDuration => Duration(minutes: workMinutes);
  Duration get restDuration => Duration(minutes: restMinutes);

  Duration workRemaining = const Duration(minutes: 25);
  Duration restRemaining = const Duration(minutes: 5);

  bool isWorking = true;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    workRemaining = Duration(minutes: workMinutes);
    restRemaining = Duration(minutes: restMinutes);
  }

  @override
  void dispose() {
    isRunning = false;
    super.dispose();
  }

  void start() {
    if (!isRunning) {
      setState(() {
        isRunning = true;
      });
      tick();
    }
  }

  void stop() {
    setState(() {
      isRunning = false;
    });
  }

  void reset() {
    setState(() {
      isRunning = false;
      isWorking = true;
      workRemaining = Duration(minutes: workMinutes);
      restRemaining = Duration(minutes: restMinutes);
    });
  }

  void tick() async {
    if (!isRunning) return;
    await Future.delayed(const Duration(seconds: 1));
    if (!isRunning) return;

    setState(() {
      if (isWorking) {
        if (workRemaining.inSeconds > 0) {
          workRemaining -= const Duration(seconds: 1);
        } else {
          isWorking = false;
        }
      } else {
        if (restRemaining.inSeconds > 0) {
          restRemaining -= const Duration(seconds: 1);
        } else {
          isWorking = true;
          workRemaining = Duration(minutes: workMinutes);
          restRemaining = Duration(minutes: restMinutes);
        }
      }
    });

    if (isRunning) tick();
  }

  String format(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isWorking ? "On Work" : "On Rest",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Chrono Travail
            Column(
              children: [
                if (!isRunning) // Affiche uniquement si non démarré
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      minimumSize: const Size(36, 36),
                    ),
                    onPressed: () {
                      setState(() {
                        if (workMinutes < 99) workMinutes++;
                        workRemaining = Duration(minutes: workMinutes);
                      });
                    },
                    child: const Icon(Icons.arrow_drop_up, color: Colors.white),
                  ),
                const Text("Work", style: TextStyle(color: Colors.white)),
                Text(
                  format(workRemaining),
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
                if (!isRunning) // Affiche uniquement si non démarré
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      minimumSize: const Size(36, 36),
                    ),
                    onPressed: () {
                      setState(() {
                        if (workMinutes > 1) workMinutes--;
                        workRemaining = Duration(minutes: workMinutes);
                      });
                    },
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ),
                Text(
                  '${workMinutes.toString().padLeft(2, '0')} min',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(width: 32),
            // Chrono Repos
            Column(
              children: [
                if (!isRunning) // Affiche uniquement si non démarré
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      minimumSize: const Size(36, 36),
                    ),
                    onPressed: () {
                      setState(() {
                        if (restMinutes < 99) restMinutes++;
                        restRemaining = Duration(minutes: restMinutes);
                      });
                    },
                    child: const Icon(Icons.arrow_drop_up, color: Colors.white),
                  ),
                const Text("Rest", style: TextStyle(color: Colors.white)),
                Text(
                  format(restRemaining),
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
                if (!isRunning) // Affiche uniquement si non démarré
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      minimumSize: const Size(36, 36),
                    ),
                    onPressed: () {
                      setState(() {
                        if (restMinutes > 1) restMinutes--;
                        restRemaining = Duration(minutes: restMinutes);
                      });
                    },
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ),
                Text(
                  '${restMinutes.toString().padLeft(2, '0')} min',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 2),
              ),
              onPressed: isRunning ? null : start,
              child: const Text('Start'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 2),
              ),
              onPressed: isRunning ? stop : null,
              child: const Text('Stop'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 2),
              ),
              onPressed: reset,
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}
