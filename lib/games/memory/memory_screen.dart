import 'package:flutter/material.dart';
import 'dart:math';
import 'card_model.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  List<MemoryCard> cards = [];
  List<int> flippedCards = [];
  int matchedPairs = 0;
  bool isProcessing = false;

  final List<String> emojis = [
    '🎮', '🎯', '🎲', '🎪', '🎨', '🎭', '🎸', '🎺',
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final random = Random();
    final selectedEmojis = emojis.take(8).toList()..shuffle(random);
    final pairs = [...selectedEmojis, ...selectedEmojis];
    pairs.shuffle(random);

    setState(() {
      cards = List.generate(
        16,
        (index) => MemoryCard(
          id: index,
          emoji: pairs[index],
          isFlipped: false,
          isMatched: false,
        ),
      );
      flippedCards = [];
      matchedPairs = 0;
      isProcessing = false;
    });
  }

  void _flipCard(int index) {
    if (isProcessing ||
        cards[index].isFlipped ||
        cards[index].isMatched ||
        flippedCards.length >= 2) {
      return;
    }

    setState(() {
      cards[index].isFlipped = true;
      flippedCards.add(index);
    });

    if (flippedCards.length == 2) {
      _checkMatch();
    }
  }

  void _checkMatch() {
    isProcessing = true;
    final firstIndex = flippedCards[0];
    final secondIndex = flippedCards[1];

    if (cards[firstIndex].emoji == cards[secondIndex].emoji) {
      // Match found
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          cards[firstIndex].isMatched = true;
          cards[secondIndex].isMatched = true;
          flippedCards.clear();
          matchedPairs++;
          isProcessing = false;
        });

        if (matchedPairs == 8) {
          _showWinDialog();
        }
      });
    } else {
      // No match
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        setState(() {
          cards[firstIndex].isFlipped = false;
          cards[secondIndex].isFlipped = false;
          flippedCards.clear();
          isProcessing = false;
        });
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 You Win!'),
        content: const Text('Congratulations! You matched all pairs!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Cards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeGame,
            tooltip: 'New Game',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Pairs Matched: $matchedPairs / 8',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  return _CardWidget(
                    card: cards[index],
                    onTap: () => _flipCard(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardWidget extends StatelessWidget {
  final MemoryCard card;
  final VoidCallback onTap;

  const _CardWidget({
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: animation,
            child: child,
          );
        },
        child: card.isFlipped || card.isMatched
            ? Container(
                key: const ValueKey('flipped'),
                decoration: BoxDecoration(
                  color: card.isMatched
                      ? Colors.green.shade200
                      : Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    card.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              )
            : Container(
                key: const ValueKey('back'),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: const Icon(
                  Icons.help_outline,
                  size: 32,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }
}


