import '../entities/player.dart';
import '../repositories/ai_strategy.dart';

/// Returns the cell index (0-8) for the bot's next move using the injected strategy.
class GetBotMoveUseCase {
  GetBotMoveUseCase(this._strategy);

  final AiStrategy _strategy;

  int call(List<Player?> board, Player botPlayer) {
    return _strategy.getMove(board, botPlayer);
  }
}
