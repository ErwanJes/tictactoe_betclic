import 'package:tictactoe_betclic/domain/entities/game_state.dart';
import 'package:tictactoe_betclic/domain/repositories/game_repository.dart';

/// Applies a human or bot move at the given index. Returns the new game state.
/// Throws [InvalidMoveException] if the move is invalid.
class PlayTurnUseCase {
  PlayTurnUseCase(this._repository);

  final GameRepository _repository;

  GameState call(int index) {
    return _repository.applyMove(index);
  }
}
