import '../../domain/entities/player.dart';
import '../../domain/repositories/ai_strategy.dart';

/// Difficulty 3: optimal play using minimax.
class MinimaxAiStrategy implements AiStrategy {
  @override
  int getMove(List<Player?> board, Player botPlayer) {
    var bestScore = -1000;
    var bestMove = -1;
    for (var i = 0; i < 9; i++) {
      if (board[i] != null) continue;
      final newBoard = List<Player?>.from(board)..[i] = botPlayer;
      final score = _minimax(newBoard, false, botPlayer);
      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }
    if (bestMove < 0) {
      // Fallback: first empty cell
      for (var i = 0; i < 9; i++) {
        if (board[i] == null) return i;
      }
    }
    return bestMove;
  }

  int _minimax(List<Player?> board, bool isMaximizing, Player botPlayer) {
    final opponent = botPlayer.opposite;
    final (result, _) = _evaluate(board, botPlayer);
    if (result != null) {
      if (result == (botPlayer == Player.x ? 1 : -1)) return 1;  // bot win
      if (result == (opponent == Player.x ? 1 : -1)) return -1;   // opponent win
      return 0; // draw
    }

    if (isMaximizing) {
      var best = -1000;
      for (var i = 0; i < 9; i++) {
        if (board[i] != null) continue;
        final newBoard = List<Player?>.from(board)..[i] = botPlayer;
        best = _max(best, _minimax(newBoard, false, botPlayer));
      }
      return best;
    } else {
      var best = 1000;
      for (var i = 0; i < 9; i++) {
        if (board[i] != null) continue;
        final newBoard = List<Player?>.from(board)..[i] = opponent;
        best = _min(best, _minimax(newBoard, true, botPlayer));
      }
      return best;
    }
  }

  /// Returns (1 for X win, -1 for O win, 0 for draw, null for playing).
  (int?, List<int>?) _evaluate(List<Player?> board, Player botPlayer) {
    const lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];
    for (final line in lines) {
      final a = board[line[0]];
      final b = board[line[1]];
      final c = board[line[2]];
      if (a != null && a == b && b == c) {
        final score = a == Player.x ? 1 : -1;
        return (score, line);
      }
    }
    final isFull = board.every((c) => c != null);
    if (isFull) return (0, null);
    return (null, null);
  }

  int _max(int a, int b) => a > b ? a : b;
  int _min(int a, int b) => a < b ? a : b;
}
