class Board {
  List<String?> cells;

  Board() : cells = List.filled(9, null);

  Board copy() {
    final newBoard = Board();
    newBoard.cells = List.from(cells);
    return newBoard;
  }

  bool isFull() {
    return cells.every((cell) => cell != null);
  }

  bool isNotFull() {
    return !isFull();
  }

  List<int> getEmptyCells() {
    return List.generate(9, (index) => index)
        .where((index) => cells[index] == null)
        .toList();
  }

  Map<String, dynamic>? checkWinner() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      final start = i * 3;
      if (cells[start] != null &&
          cells[start] == cells[start + 1] &&
          cells[start] == cells[start + 2]) {
        return {
          'winner': cells[start],
          'cells': [start, start + 1, start + 2],
        };
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (cells[i] != null &&
          cells[i] == cells[i + 3] &&
          cells[i] == cells[i + 6]) {
        return {
          'winner': cells[i],
          'cells': [i, i + 3, i + 6],
        };
      }
    }

    // Check diagonals
    if (cells[0] != null &&
        cells[0] == cells[4] &&
        cells[0] == cells[8]) {
      return {
        'winner': cells[0],
        'cells': [0, 4, 8],
      };
    }

    if (cells[2] != null &&
        cells[2] == cells[4] &&
        cells[2] == cells[6]) {
      return {
        'winner': cells[2],
        'cells': [2, 4, 6],
      };
    }

    return null;
  }
}


