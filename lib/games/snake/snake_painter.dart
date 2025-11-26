import 'package:flutter/material.dart';

class SnakePainter extends CustomPainter {
  final List<Offset> snake;
  final Offset? food;
  final int gridSize;
  final int cellSize;

  SnakePainter({
    required this.snake,
    required this.food,
    required this.gridSize,
    required this.cellSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw grid background
    paint.color = Colors.grey.shade100;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Draw grid lines
    paint.color = Colors.grey.shade300;
    paint.strokeWidth = 1;
    for (int i = 0; i <= gridSize; i++) {
      final pos = (i * cellSize).toDouble();
      canvas.drawLine(
        Offset(pos, 0),
        Offset(pos, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(0, pos),
        Offset(size.width, pos),
        paint,
      );
    }

    // Draw food
    if (food != null) {
      paint.color = Colors.red;
      canvas.drawCircle(
        Offset(food!.dx * cellSize + cellSize / 2,
            food!.dy * cellSize + cellSize / 2),
        cellSize / 2 - 2,
        paint,
      );
    }

    // Draw snake
    for (int i = 0; i < snake.length; i++) {
      paint.color = i == 0 ? Colors.green.shade700 : Colors.green.shade400;
      final cell = snake[i];
      canvas.drawRect(
        Rect.fromLTWH(
          cell.dx * cellSize + 1,
          cell.dy * cellSize + 1,
          cellSize - 2,
          cellSize - 2,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(SnakePainter oldDelegate) {
    return snake != oldDelegate.snake || food != oldDelegate.food;
  }
}


