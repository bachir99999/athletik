import 'package:flutter/material.dart';

class PomodoroWidget extends StatefulWidget {
  const PomodoroWidget({super.key});

  @override
  State<PomodoroWidget> createState() => _PomodoroWidgetState();
}

class _PomodoroWidgetState extends State<PomodoroWidget> {
  int workMinutes = 25;
  int restMinutes = 5;
  int totalRounds = 4;
  int currentRound = 1;

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
      currentRound = 1;
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
          if (currentRound < totalRounds) {
            currentRound++;
            isWorking = true;
            workRemaining = Duration(minutes: workMinutes);
            restRemaining = Duration(minutes: restMinutes);
          } else {
            // Fin des rounds
            isRunning = false;
          }
        }
      }
    });

    if (isRunning) tick();
  }

  String format(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final Color workColor = Colors.red.shade700;
    final Color restColor = Colors.green.shade700;

    return Column(
      children: [
        Text(
          isWorking ? "On Work" : "On Rest",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isWorking ? workColor : restColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isRunning)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue, width: 2),
                  minimumSize: const Size(36, 36),
                ),
                onPressed: () {
                  setState(() {
                    if (totalRounds < 99) totalRounds++;
                  });
                },
                child: const Icon(Icons.arrow_drop_up, color: Colors.blue),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const Text("Rounds", style: TextStyle(color: Colors.blue)),
                  Text(
                    '$currentRound / $totalRounds',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (!isRunning)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue, width: 2),
                  minimumSize: const Size(36, 36),
                ),
                onPressed: () {
                  setState(() {
                    if (totalRounds > 1) totalRounds--;
                  });
                },
                child: const Icon(Icons.arrow_drop_down, color: Colors.blue),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Chrono Travail
            Container(
              decoration: BoxDecoration(
                color: workColor.withAlpha(!isWorking ? 50 : 25),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  if (!isRunning)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: workColor,
                        side: BorderSide(color: workColor, width: 2),
                        minimumSize: const Size(36, 36),
                      ),
                      onPressed: () {
                        setState(() {
                          if (workMinutes < 99) workMinutes++;
                          workRemaining = Duration(minutes: workMinutes);
                        });
                      },
                      child: Icon(Icons.arrow_drop_up, color: workColor),
                    ),
                  Text(
                    "Work",
                    style: TextStyle(
                      color: workColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    format(workRemaining),
                    style: TextStyle(
                      fontSize: 32,
                      color: workColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!isRunning)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: workColor,
                        side: BorderSide(color: workColor, width: 2),
                        minimumSize: const Size(36, 36),
                      ),
                      onPressed: () {
                        setState(() {
                          if (workMinutes > 1) workMinutes--;
                          workRemaining = Duration(minutes: workMinutes);
                        });
                      },
                      child: Icon(Icons.arrow_drop_down, color: workColor),
                    ),
                  Text(
                    '${workMinutes.toString().padLeft(2, '0')} min',
                    style: TextStyle(
                      color: workColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 32),
            // Chrono Repos
            Container(
              decoration: BoxDecoration(
                color: restColor.withAlpha(!isWorking ? 50 : 25),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  if (!isRunning)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: restColor,
                        side: BorderSide(color: restColor, width: 2),
                        minimumSize: const Size(36, 36),
                      ),
                      onPressed: () {
                        setState(() {
                          if (restMinutes < 99) restMinutes++;
                          restRemaining = Duration(minutes: restMinutes);
                        });
                      },
                      child: Icon(Icons.arrow_drop_up, color: restColor),
                    ),
                  Text(
                    "Rest",
                    style: TextStyle(
                      color: restColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    format(restRemaining),
                    style: TextStyle(
                      fontSize: 32,
                      color: restColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!isRunning)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: restColor,
                        side: BorderSide(color: restColor, width: 2),
                        minimumSize: const Size(36, 36),
                      ),
                      onPressed: () {
                        setState(() {
                          if (restMinutes > 1) restMinutes--;
                          restRemaining = Duration(minutes: restMinutes);
                        });
                      },
                      child: Icon(Icons.arrow_drop_down, color: restColor),
                    ),
                  Text(
                    '${restMinutes.toString().padLeft(2, '0')} min',
                    style: TextStyle(
                      color: restColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.white, width: 2),
              ),
              onPressed: isRunning ? null : start,
              child: const Text('Start'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.white, width: 2),
              ),
              onPressed: isRunning ? stop : null,
              child: const Text('Stop'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: FilledButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.white, width: 2),
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
