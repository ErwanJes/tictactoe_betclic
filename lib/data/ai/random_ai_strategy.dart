import 'dart:math';

import '../../domain/entities/player.dart';
import '../../domain/repositories/ai_strategy.dart';

/// Difficulty 1: picks a random empty cell.
class RandomAiStrategy implements AiStrategy {
  final Random _random = Random();

  @override
  int getMove(List<Player?> board, Player botPlayer) {
    final empty = <int>[];
    for (var i = 0; i < 9; i++) {
      if (board[i] == null) {
        empty.add(i);
      }
    }
    if (empty.isEmpty) {
      throw StateError('No empty cell');
    }
    return empty[_random.nextInt(empty.length)];
  }
}
