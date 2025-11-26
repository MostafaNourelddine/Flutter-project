import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Block {
  double x;
  double y;
  double width;
  double height;

  Block({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  Rect get rect => Rect.fromLTWH(x, y, width, height);
}

class AvoidBlocksScreen extends StatefulWidget {
  const AvoidBlocksScreen({super.key});

  @override
  State<AvoidBlocksScreen> createState() => _AvoidBlocksScreenState();
}

class _AvoidBlocksScreenState extends State<AvoidBlocksScreen> {
  static const double playerSize = 50.0;
  static const double blockWidth = 60.0;
  static const double blockHeight = 60.0;
  static const double playerSpeed = 5.0;
  static const double initialBlockSpeed = 2.0;

  double playerX = 0;
  double blockSpeed = initialBlockSpeed;
  List<Block> blocks = [];
  Timer? gameTimer;
  bool isGameOver = false;
  bool isMovingLeft = false;
  bool isMovingRight = false;
  int score = 0;
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGame();
    });
  }

  void _startGame() {
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!isGameOver) {
        setState(() {
          _updateGame();
        });
      }
    });

    // Spawn blocks periodically
    Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (!isGameOver && screenWidth > 0) {
        _spawnBlock();
      } else {
        timer.cancel();
      }
    });
  }

  void _updateGame() {
    // Move player
    if (isMovingLeft && playerX > 0) {
      playerX -= playerSpeed;
    }
    if (isMovingRight && playerX < screenWidth - playerSize) {
      playerX += playerSpeed;
    }

    // Move blocks
    blocks.removeWhere((block) {
      block.y += blockSpeed;
      return block.y > screenHeight;
    });

    // Increase speed over time
    blockSpeed = initialBlockSpeed + (score / 100);

    // Check collisions
    final playerRect = Rect.fromLTWH(
      playerX,
      screenHeight - playerSize - 20,
      playerSize,
      playerSize,
    );

    for (final block in blocks) {
      if (playerRect.overlaps(block.rect)) {
        _gameOver();
        return;
      }
    }

    // Update score
    score++;
  }

  void _spawnBlock() {
    final random = Random();
    final x = random.nextDouble() * (screenWidth - blockWidth);
    blocks.add(Block(
      x: x,
      y: -blockHeight,
      width: blockWidth,
      height: blockHeight,
    ));
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
      playerX = 0;
      blocks.clear();
      isGameOver = false;
      blockSpeed = initialBlockSpeed;
      score = 0;
      isMovingLeft = false;
      isMovingRight = false;
    });
    _startGame();
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
        title: const Text('Avoid the Blocks'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          screenWidth = constraints.maxWidth;
          screenHeight = constraints.maxHeight;

          return Stack(
            children: [
              // Game area
              GestureDetector(
                onPanUpdate: (details) {
                  if (!isGameOver) {
                    final delta = details.delta.dx;
                    if (delta > 0) {
                      isMovingRight = true;
                      isMovingLeft = false;
                    } else if (delta < 0) {
                      isMovingLeft = true;
                      isMovingRight = false;
                    }
                  }
                },
                onPanEnd: (details) {
                  isMovingLeft = false;
                  isMovingRight = false;
                },
                child: CustomPaint(
                  painter: _GamePainter(
                    playerX: playerX,
                    playerSize: playerSize,
                    blocks: blocks,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  size: Size(screenWidth, screenHeight),
                ),
              ),
              // Score
              Positioned(
                top: 20,
                left: 20,
                child: Text(
                  'Score: $score',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                ),
              ),
              // Control buttons
              Positioned(
                bottom: 20,
                left: 20,
                child: _ControlButton(
                  icon: Icons.arrow_back,
                  onPressed: () {
                    if (!isGameOver) {
                      setState(() {
                        isMovingLeft = true;
                      });
                    }
                  },
                  onReleased: () {
                    setState(() {
                      isMovingLeft = false;
                    });
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: _ControlButton(
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    if (!isGameOver) {
                      setState(() {
                        isMovingRight = true;
                      });
                    }
                  },
                  onReleased: () {
                    setState(() {
                      isMovingRight = false;
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback onReleased;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.onReleased,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
        widget.onPressed();
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
        widget.onReleased();
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
        widget.onReleased();
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isPressed
              ? Colors.blue.shade700
              : Colors.blue.shade400,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          widget.icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class _GamePainter extends CustomPainter {
  final double playerX;
  final double playerSize;
  final List<Block> blocks;
  final double screenWidth;
  final double screenHeight;

  _GamePainter({
    required this.playerX,
    required this.playerSize,
    required this.blocks,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    final backgroundPaint = Paint()..color = Colors.grey.shade900;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, screenWidth, screenHeight),
      backgroundPaint,
    );

    // Draw player
    final playerPaint = Paint()..color = Colors.blue;
    canvas.drawRect(
      Rect.fromLTWH(
        playerX,
        screenHeight - playerSize - 20,
        playerSize,
        playerSize,
      ),
      playerPaint,
    );

    // Draw blocks
    final blockPaint = Paint()..color = Colors.red;
    for (final block in blocks) {
      canvas.drawRect(block.rect, blockPaint);
    }
  }

  @override
  bool shouldRepaint(_GamePainter oldDelegate) {
    return playerX != oldDelegate.playerX ||
        blocks.length != oldDelegate.blocks.length ||
        blocks != oldDelegate.blocks;
  }
}


