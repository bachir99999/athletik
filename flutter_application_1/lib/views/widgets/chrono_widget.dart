import 'package:flutter/material.dart';

class ChronoWidget extends StatefulWidget {
  final VoidCallback? onTick;

  const ChronoWidget({Key? key, this.onTick}) : super(key: key);

  @override
  State<ChronoWidget> createState() => _ChronoWidgetState();
}

class _ChronoWidgetState extends State<ChronoWidget> {
  Duration remaining = Duration.zero;
  bool isRunning = false;
  final TextEditingController _controller = TextEditingController();
  bool hasStarted = false;

  @override
  void dispose() {
    isRunning = false;
    _controller.dispose();
    super.dispose();
  }

  void startTimer() {
    if (!isRunning && remaining.inSeconds > 0) {
      setState(() {
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
      _controller.clear();
    });
  }

  void setInitialTime() {
    final input = int.tryParse(_controller.text);
    if (input != null && input > 0) {
      setState(() {
        remaining = Duration(seconds: input);
        hasStarted = false;
      });
    }
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
    int minutes = remaining.inMinutes;
    int seconds = remaining.inSeconds % 60;
    int centiseconds = (remaining.inMilliseconds % 1000) ~/ 10; // 2 digits

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!hasStarted) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Secondes'),
                  onSubmitted: (_) => setInitialTime(),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white, // Texte blanc
                  side: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ), // Bordure blanche
                ),
                onPressed: setInitialTime,
                child: const Text('Valider'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Text(
          '$minutes:${seconds.toString().padLeft(2, '0')}:${centiseconds.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white, // Texte blanc
                side: const BorderSide(
                  color: Colors.white,
                  width: 2,
                ), // Bordure blanche
              ),
              onPressed:
                  (!isRunning && remaining.inMilliseconds > 0)
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
