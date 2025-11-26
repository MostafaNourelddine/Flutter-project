import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'snake_painter.dart';

enum Direction { up, down, left, right }

class SnakeScreen extends StatefulWidget {
  const SnakeScreen({super.key});

  @override
  State<SnakeScreen> createState() => _SnakeScreenState();
}

class _SnakeScreenState extends State<SnakeScreen> {
  static const int gridSize = 20;
  static const int cellSize = 20;

  List<Offset> snake = [
    const Offset(10, 10),
    const Offset(10, 11),
    const Offset(10, 12),
  ];
  Offset? food;
  Direction direction = Direction.up;
  Direction nextDirection = Direction.up;
  Timer? gameTimer;
  bool isGameOver = false;
  bool isPaused = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _generateFood();
    gameTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!isPaused && !isGameOver) {
        setState(() {
          _moveSnake();
        });
      }
    });
  }

  void _generateFood() {
    final random = Random();
    Offset newFood;
    do {
      newFood = Offset(
        random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble(),
      );
    } while (snake.contains(newFood));

    food = newFood;
  }

  void _moveSnake() {
    direction = nextDirection;
    Offset head = snake.first;
    Offset newHead;

    switch (direction) {
      case Direction.up:
        newHead = Offset(head.dx, head.dy - 1);
        break;
      case Direction.down:
        newHead = Offset(head.dx, head.dy + 1);
        break;
      case Direction.left:
        newHead = Offset(head.dx - 1, head.dy);
        break;
      case Direction.right:
        newHead = Offset(head.dx + 1, head.dy);
        break;
    }

    // Check wall collision
    if (newHead.dx < 0 ||
        newHead.dx >= gridSize ||
        newHead.dy < 0 ||
        newHead.dy >= gridSize) {
      _gameOver();
      return;
    }

    // Check self collision
    if (snake.contains(newHead)) {
      _gameOver();
      return;
    }

    snake.insert(0, newHead);

    // Check food collision
    if (newHead == food) {
      score++;
      _generateFood();
    } else {
      snake.removeLast();
    }
  }

  void _gameOver() {
    isGameOver = true;
    gameTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      snake = [
        const Offset(10, 10),
        const Offset(10, 11),
        const Offset(10, 12),
      ];
      direction = Direction.up;
      nextDirection = Direction.up;
      isGameOver = false;
      isPaused = false;
      score = 0;
    });
    _generateFood();
    _startGame();
  }

  void _handleSwipe(DragUpdateDetails details) {
    if (isGameOver || isPaused) return;

    final dx = details.delta.dx;
    final dy = details.delta.dy;

    if (dx.abs() > dy.abs()) {
      // Horizontal swipe
      if (dx > 0 && direction != Direction.left) {
        nextDirection = Direction.right;
      } else if (dx < 0 && direction != Direction.right) {
        nextDirection = Direction.left;
      }
    } else {
      // Vertical swipe
      if (dy > 0 && direction != Direction.up) {
        nextDirection = Direction.down;
      } else if (dy < 0 && direction != Direction.down) {
        nextDirection = Direction.up;
      }
    }
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake'),
        actions: [
          IconButton(
            icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: () {
              setState(() {
                isPaused = !isPaused;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Score: $score',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanUpdate: _handleSwipe,
              child: CustomPaint(
                painter: SnakePainter(
                  snake: snake,
                  food: food,
                  gridSize: gridSize,
                  cellSize: cellSize,
                ),
                child: Container(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _resetGame,
              icon: const Icon(Icons.refresh),
              label: const Text('Restart'),
            ),
          ),
        ],
      ),
    );
  }
}

