import 'game_result.dart';

/// Current status of the game.
sealed class GameStatus {
  const GameStatus();
}

/// Game is still in progress.
final class GameStatusPlaying extends GameStatus {
  const GameStatusPlaying();
}

/// Game has ended with a result.
final class GameStatusOver extends GameStatus {
  const GameStatusOver(this.result);

  final GameResult result;
}
