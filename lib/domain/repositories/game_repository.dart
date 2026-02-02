import 'package:tictactoe_betclic/domain/entities/game_state.dart';

/// Abstraction for game persistence and transitions.
/// Implementations hold current board state and apply moves.
abstract interface class GameRepository {
  /// Returns the current game state, or null if no game has been started.
  GameState? getState();

  /// Starts a new game with the given difficulty (1-3). Returns initial state.
  GameState startNewGame(int difficulty);

  /// Applies a move at the given cell index (0-8).
  /// Returns the new game state.
  /// Throws [InvalidMoveException] if the cell is already filled or game is over.
  GameState applyMove(int index);
}

/// Thrown when an invalid move is attempted.
final class InvalidMoveException implements Exception {
  InvalidMoveException(this.message);
  final String message;
  @override
  String toString() => 'InvalidMoveException: $message';
}
