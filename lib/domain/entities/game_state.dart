import 'player.dart';
import 'game_status.dart';

/// Immutable state of the current game.
class GameState {
  const GameState({
    required this.board,
    required this.currentPlayer,
    required this.status,
    this.winningLine,
    this.difficulty = 1,
  });

  /// Flat list of 9 cells; index 0 = top-left, 8 = bottom-right.
  /// null = empty cell.
  final List<Player?> board;

  /// Whose turn it is (X or O).
  final Player currentPlayer;

  /// Whether the game is still playing or over.
  final GameStatus status;

  /// Indices of the three winning cells (0-8), if status is GameStatusOver with a win.
  /// null for draw or when game is playing.
  final List<int>? winningLine;

  /// AI difficulty (1-3) for the current game.
  final int difficulty;

  GameState copyWith({
    List<Player?>? board,
    Player? currentPlayer,
    GameStatus? status,
    List<int>? winningLine,
    int? difficulty,
  }) {
    return GameState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      status: status ?? this.status,
      winningLine: winningLine ?? this.winningLine,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
