import 'package:tictactoe_betclic/domain/entities/game_result.dart';
import 'package:tictactoe_betclic/domain/entities/player.dart';

/// Pure logic: given a board, returns the game result and winning line if any.
class CheckGameOverUseCase {
  /// Returns (result, winningLine). winningLine is the list of 3 indices if win, null for draw or playing.
  /// Returns null for result if game is still playing.
  (GameResult? result, List<int>? winningLine) call(List<Player?> board) {
    final win = _findWin(board);
    if (win != null) {
      final winner = board[win[0]]!;
      // Human is X, bot is O. So X win = human, O win = bot.
      final result = winner == Player.x
          ? GameResult.humanWin
          : GameResult.botWin;
      return (result, win);
    }
    final isFull = board.every((cell) => cell != null);
    if (isFull) {
      return (GameResult.draw, null);
    }
    return (null, null);
  }

  static const List<List<int>> _lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  List<int>? _findWin(List<Player?> board) {
    for (final line in _lines) {
      final a = board[line[0]];
      final b = board[line[1]];
      final c = board[line[2]];
      if (a != null && a == b && b == c) {
        return line;
      }
    }
    return null;
  }
}
