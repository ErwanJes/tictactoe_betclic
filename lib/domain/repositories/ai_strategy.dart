import 'package:tictactoe_betclic/domain/entities/player.dart';

/// Abstraction for AI move selection. Implementations per difficulty live in data layer.
abstract interface class AiStrategy {
  /// Returns the cell index (0-8) where the bot should play.
  /// [board] is a flat list of 9 cells; null = empty.
  /// [botPlayer] is the symbol the bot plays (X or O).
  int getMove(List<Player?> board, Player botPlayer);
}
