import 'package:flutter/material.dart';

class ChronoWidget extends StatefulWidget {
  final VoidCallback? onTick;

  const ChronoWidget({Key? key, this.onTick}) : super(key: key);

  @override
  State<ChronoWidget> createState() => _ChronoWidgetState();
}

class _ChronoWidgetState extends State<ChronoWidget> {
  int selectedMinutes = 0;
  int selectedSeconds = 0;
  Duration remaining = Duration.zero;
  bool isRunning = false;
  bool hasStarted = false;

  @override
  void dispose() {
    isRunning = false;
    super.dispose();
  }

  void startTimer() {
    if (!isRunning &&
        (selectedMinutes > 0 ||
            selectedSeconds > 0 ||
            remaining.inMilliseconds > 0)) {
      setState(() {
        if (!hasStarted) {
          remaining = Duration(
            minutes: selectedMinutes,
            seconds: selectedSeconds,
          );
        }
        isRunning = true;
        hasStarted = true;
      });
      tick();
    }
  }

  void stopTimer() {
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    setState(() {
      isRunning = false;
      hasStarted = false;
      remaining = Duration.zero;
      selectedMinutes = 0;
      selectedSeconds = 0;
    });
  }

  void tick() async {
    if (!isRunning) return;
    await Future.delayed(const Duration(milliseconds: 10));
    if (isRunning && remaining.inMilliseconds > 0) {
      setState(() {
        remaining -= const Duration(milliseconds: 10);
        if (remaining.inMilliseconds < 0) {
          remaining = Duration.zero;
        }
      });
      widget.onTick?.call();
      tick();
    } else {
      setState(() {
        isRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int minutes = hasStarted ? remaining.inMinutes : selectedMinutes;
    int seconds = hasStarted ? remaining.inSeconds % 60 : selectedSeconds;
    int centiseconds = hasStarted ? (remaining.inMilliseconds % 1000) ~/ 10 : 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!hasStarted) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Minutes
              Column(
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      minimumSize: const Size(40, 40),
                    ),
                    onPressed: () {
                      setState(() {
                        if (selectedMinutes < 99) selectedMinutes++;
                      });
                    },
                    child: const Icon(Icons.arrow_drop_up, color: Colors.white),
                  ),
                  Text(
                    selectedMinutes.toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      minimumSize: const Size(40, 40),
                    ),
                    onPressed: () {
                      setState(() {
                        if (selectedMinutes > 0) selectedMinutes--;
                      });
                    },
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ),
                  const Text('min', style: TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(width: 32),
              // Secondes
              Column(
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      minimumSize: const Size(40, 40),
                    ),
                    onPressed: () {
                      setState(() {
                        if (selectedSeconds < 59) selectedSeconds += 5;
                      });
                    },
                    child: const Icon(Icons.arrow_drop_up, color: Colors.white),
                  ),
                  Text(
                    selectedSeconds.toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      minimumSize: const Size(40, 40),
                    ),
                    onPressed: () {
                      setState(() {
                        if (selectedSeconds > 0) selectedSeconds -= 5;
                      });
                    },
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ),
                  const Text('sec', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        Text(
          '$minutes:${seconds.toString().padLeft(2, '0')}:${centiseconds.toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 2),
              ),
              onPressed:
                  (!isRunning && (minutes > 0 || seconds > 0))
                      ? startTimer
                      : null,
              child: const Text('Start'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 2),
              ),
              onPressed: isRunning ? stopTimer : null,
              child: const Text('Stop'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 2),
              ),
              onPressed: hasStarted ? resetTimer : null,
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}
