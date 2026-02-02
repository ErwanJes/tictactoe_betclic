import 'dart:math';

import '../../domain/entities/player.dart';
import '../../domain/repositories/ai_strategy.dart';

/// Difficulty 2: blocks opponent win if one move away, otherwise random.
class BlockWinAiStrategy implements AiStrategy {
  static const List<List<int>> _lines = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6],
  ];

  final Random _random = Random();

  @override
  int getMove(List<Player?> board, Player botPlayer) {
    final opponent = botPlayer.opposite;

    // Try to block opponent win (two opponent + one empty).
    for (final line in _lines) {
      final cells = line.map((i) => board[i]).toList();
      final oppCount = cells.where((c) => c == opponent).length;
      final emptyCount = cells.where((c) => c == null).length;
      if (oppCount == 2 && emptyCount == 1) {
        final emptyIndex = line.firstWhere((i) => board[i] == null);
        return emptyIndex;
      }
    }

    // Try to win (two bot + one empty).
    for (final line in _lines) {
      final cells = line.map((i) => board[i]).toList();
      final botCount = cells.where((c) => c == botPlayer).length;
      final emptyCount = cells.where((c) => c == null).length;
      if (botCount == 2 && emptyCount == 1) {
        final emptyIndex = line.firstWhere((i) => board[i] == null);
        return emptyIndex;
      }
    }

    // Otherwise random.
    final empty = <int>[];
    for (var i = 0; i < 9; i++) {
      if (board[i] == null) empty.add(i);
    }
    return empty[_random.nextInt(empty.length)];
  }
}
