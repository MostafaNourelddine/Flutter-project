import 'package:flutter/material.dart';
import 'board.dart';
import 'ai.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late Board _board;
  bool _isPlayerTurn = true;
  String? _winner;
  List<int>? _winningCells;

  @override
  void initState() {
    super.initState();
    _board = Board();
  }

  void _makeMove(int index) {
    if (!_isPlayerTurn || _board.cells[index] != null || _winner != null) {
      return;
    }

    setState(() {
      _board.cells[index] = 'X';
      _checkGameState();

      if (_winner == null && _board.isNotFull()) {
        // AI's turn
        _isPlayerTurn = false;
        _aiMove();
      }
    });
  }

  void _aiMove() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final aiMove = AI.getBestMove(_board);
      setState(() {
        _board.cells[aiMove] = 'O';
        _isPlayerTurn = true;
        _checkGameState();
      });
    });
  }

  void _checkGameState() {
    final result = _board.checkWinner();
    if (result != null) {
      _winner = result['winner'];
      _winningCells = result['cells'];
    } else if (_board.isFull()) {
      _winner = 'Draw';
    }
  }

  void _resetGame() {
    setState(() {
      _board = Board();
      _isPlayerTurn = true;
      _winner = null;
      _winningCells = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_winner != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _winner == 'Draw'
                      ? 'It\'s a Draw!'
                      : '$_winner Wins!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: _winner == 'X'
                            ? Colors.blue
                            : _winner == 'O'
                                ? Colors.red
                                : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            const SizedBox(height: 20),
            _buildBoard(),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _resetGame,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Game'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          final isWinningCell =
              _winningCells != null && _winningCells!.contains(index);
          return _buildCell(index, isWinningCell);
        },
      ),
    );
  }

  Widget _buildCell(int index, bool isWinning) {
    final cellValue = _board.cells[index];
    return GestureDetector(
      onTap: () => _makeMove(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          color: isWinning
              ? Colors.yellow.withOpacity(0.3)
              : Colors.transparent,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: cellValue != null
                ? Text(
                    cellValue,
                    key: ValueKey('$cellValue-$index'),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: cellValue == 'X' ? Colors.blue : Colors.red,
                    ),
                  )
                : SizedBox(key: ValueKey('empty-$index')),
          ),
        ),
      ),
    );
  }
}


