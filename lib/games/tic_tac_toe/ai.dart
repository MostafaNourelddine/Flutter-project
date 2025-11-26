import 'board.dart';

class AI {
  static const String aiMark = 'O';
  static const String playerMark = 'X';

  static int getBestMove(Board board) {
    int bestScore = -1000;
    int bestMove = -1;

    for (int i = 0; i < 9; i++) {
      if (board.cells[i] == null) {
        final newBoard = board.copy();
        newBoard.cells[i] = aiMark;
        final score = minimax(newBoard, 0, false);
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    return bestMove;
  }

  static int minimax(Board board, int depth, bool isMaximizing) {
    final winner = board.checkWinner();

    // Base cases
    if (winner != null) {
      if (winner['winner'] == aiMark) {
        return 10 - depth; // Prefer faster wins
      } else if (winner['winner'] == playerMark) {
        return depth - 10; // Prefer slower losses
      }
    }

    if (board.isFull()) {
      return 0; // Draw
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board.cells[i] == null) {
          final newBoard = board.copy();
          newBoard.cells[i] = aiMark;
          final score = minimax(newBoard, depth + 1, false);
          bestScore = score > bestScore ? score : bestScore;
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board.cells[i] == null) {
          final newBoard = board.copy();
          newBoard.cells[i] = playerMark;
          final score = minimax(newBoard, depth + 1, true);
          bestScore = score < bestScore ? score : bestScore;
        }
      }
      return bestScore;
    }
  }
}


