import 'dart:ui';
import 'package:flutter/material.dart';

class RoundsWidget extends StatefulWidget {
  const RoundsWidget({super.key});

  @override
  State<RoundsWidget> createState() => _RoundsWidgetState();
}

class _RoundsWidgetState extends State<RoundsWidget> {
  int rounds = 5;
  int roundSeconds = 180;
  int restSeconds = 30;
  bool isCountingDown = false;
  int countdown = 5;

  // Ajout des variables pour le timer
  bool isRunning = false;
  int currentRound = 1;
  int currentTime = 0;
  bool isRest = false;

  Future<void> startCountdown() async {
    setState(() {
      isCountingDown = true;
      countdown = 5;
    });
    for (int i = 5; i > 0; i--) {
      setState(() {
        countdown = i;
      });
      await Future.delayed(const Duration(seconds: 1));
    }
    setState(() {
      isCountingDown = false;
    });
    // Lancer le timer après le décompte
    startRounds();
  }

  void startRounds() {
    setState(() {
      isRunning = true;
      currentRound = 1;
      isRest = false;
      currentTime = roundSeconds;
    });
    tick();
  }

  void tick() async {
    if (!isRunning) return;
    await Future.delayed(const Duration(seconds: 1));
    if (!isRunning) return;

    setState(() {
      if (currentTime > 0) {
        currentTime--;
      } else {
        if (!isRest) {
          // Fin du round, passage au repos
          isRest = true;
          currentTime = restSeconds;
        } else {
          // Fin du repos, passage au round suivant
          if (currentRound < rounds) {
            currentRound++;
            isRest = false;
            currentTime = roundSeconds;
          } else {
            // Fin de tous les rounds
            isRunning = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tous les rounds sont terminés !')),
            );
          }
        }
      }
    });

    if (isRunning) tick();
  }

  void stopRounds() {
    setState(() {
      isRunning = false;
    });
  }

  void resetRounds() {
    setState(() {
      isRunning = false;
      isCountingDown = false;
      currentRound = 1;
      isRest = false;
      currentTime = 0;
    });
  }

  String format(int seconds) =>
      '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isCountingDown || isRunning,
          child: Opacity(
            opacity: isCountingDown || isRunning ? 0.5 : 1.0,
            child: _buildMainContent(),
          ),
        ),
        if (isCountingDown)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '$countdown',
                  style: const TextStyle(
                    fontSize: 80,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        if (isRunning)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isRest ? "Repos" : "Round $currentRound / $rounds",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isRest ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          format(currentTime),
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: isRest ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 32),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: isRest ? Colors.green : Colors.red,
                              width: 2,
                            ),
                          ),
                          onPressed: stopRounds,
                          child: const Text('Stop'),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isRunning = false;
                            });
                          },
                          child: const Text('Pause'),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          onPressed: resetRounds,
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        // Sélection du nombre de rounds
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  if (rounds < 99) rounds++;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue, width: 2),
                minimumSize: const Size(36, 36),
              ),
              child: const Icon(Icons.arrow_drop_up, color: Colors.blue),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const Text("Rounds", style: TextStyle(color: Colors.blue)),
                  Text(
                    rounds.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  if (rounds > 1) rounds--;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue, width: 2),
                minimumSize: const Size(36, 36),
              ),
              child: const Icon(Icons.arrow_drop_down, color: Colors.blue),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Sélection du temps du round
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  if (roundSeconds < 600) roundSeconds += 30;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 2),
                minimumSize: const Size(36, 36),
              ),
              child: const Icon(Icons.arrow_drop_up, color: Colors.red),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const Text(
                    "Round (sec)",
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(
                    roundSeconds.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  if (roundSeconds > 1) roundSeconds -= 30;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 2),
                minimumSize: const Size(36, 36),
              ),
              child: const Icon(Icons.arrow_drop_down, color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Sélection du temps de repos
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  if (restSeconds < 600) restSeconds += 10;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green, width: 2),
                minimumSize: const Size(36, 36),
              ),
              child: const Icon(Icons.arrow_drop_up, color: Colors.green),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  const Text(
                    "Repos (sec)",
                    style: TextStyle(color: Colors.green),
                  ),
                  Text(
                    restSeconds.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  if (restSeconds > 1) restSeconds -= 10;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green, width: 2),
                minimumSize: const Size(36, 36),
              ),
              child: const Icon(Icons.arrow_drop_down, color: Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue, width: 2),
              ),
              onPressed: isCountingDown ? null : startCountdown,
              child: const Text('Démarrer'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey,
                side: const BorderSide(color: Colors.grey, width: 2),
              ),
              onPressed:
                  isCountingDown
                      ? null
                      : () {
                        setState(() {
                          rounds = 5;
                          roundSeconds = 180;
                          restSeconds = 30;
                        });
                      },
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}
