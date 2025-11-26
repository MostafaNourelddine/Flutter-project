import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';

enum ReactionState { waiting, ready, tapNow }

class ReactionScreen extends StatefulWidget {
  const ReactionScreen({super.key});

  @override
  State<ReactionScreen> createState() => _ReactionScreenState();
}

class _ReactionScreenState extends State<ReactionScreen> {
  ReactionState state = ReactionState.waiting;
  int? reactionTime;
  int? bestTime;
  DateTime? tapStartTime;
  Timer? readyTimer;

  @override
  void initState() {
    super.initState();
    _loadBestTime();
  }

  Future<void> _loadBestTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bestTime = prefs.getInt('best_reaction_time');
    });
  }

  Future<void> _saveBestTime(int time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('best_reaction_time', time);
    setState(() {
      bestTime = time;
    });
  }

  void _startTest() {
    setState(() {
      state = ReactionState.waiting;
      reactionTime = null;
    });

    final random = Random();
    final delay = Duration(
      milliseconds: 1000 + random.nextInt(2000), // 1-3 seconds
    );

    readyTimer = Timer(delay, () {
      if (mounted) {
        setState(() {
          state = ReactionState.tapNow;
          tapStartTime = DateTime.now();
        });
      }
    });
  }

  void _onTap() {
    if (state == ReactionState.tapNow && tapStartTime != null) {
      final elapsed = DateTime.now().difference(tapStartTime!);
      final timeMs = elapsed.inMilliseconds;

      setState(() {
        reactionTime = timeMs;
        state = ReactionState.waiting;
      });

      if (bestTime == null || timeMs < bestTime!) {
        _saveBestTime(timeMs);
      }
    } else if (state == ReactionState.waiting) {
      _startTest();
    } else if (state == ReactionState.ready) {
      // Tapped too early
      setState(() {
        state = ReactionState.waiting;
        reactionTime = null;
      });
      readyTimer?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Too early! Wait for the screen to turn green.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    readyTimer?.cancel();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (state) {
      case ReactionState.waiting:
        return Colors.blue.shade100;
      case ReactionState.ready:
        return Colors.orange.shade100;
      case ReactionState.tapNow:
        return Colors.green.shade300;
    }
  }

  String _getStateText() {
    switch (state) {
      case ReactionState.waiting:
        return 'Tap to Start';
      case ReactionState.ready:
        return 'Get Ready...';
      case ReactionState.tapNow:
        return 'TAP NOW!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reaction Test'),
      ),
      body: GestureDetector(
        onTap: _onTap,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: _getBackgroundColor(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getStateText(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                textAlign: TextAlign.center,
              ),
              if (reactionTime != null) ...[
                const SizedBox(height: 40),
                Text(
                  'Your Reaction Time:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  '${reactionTime}ms',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                ),
                if (bestTime != null) ...[
                  const SizedBox(height: 30),
                  Text(
                    'Best Time: ${bestTime}ms',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.green.shade700,
                        ),
                  ),
                ],
              ],
              const SizedBox(height: 60),
              if (state == ReactionState.waiting && reactionTime == null)
                ElevatedButton(
                  onPressed: _startTest,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Start Test'),
                ),
              if (reactionTime != null)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      reactionTime = null;
                    });
                    _startTest();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


