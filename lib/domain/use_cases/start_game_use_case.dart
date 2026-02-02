import 'package:tictactoe_betclic/domain/entities/game_state.dart';
import 'package:tictactoe_betclic/domain/repositories/game_repository.dart';

/// Starts a new game with the given difficulty and returns initial state.
class StartGameUseCase {
  StartGameUseCase(this._repository);

  final GameRepository _repository;

  GameState call(int difficulty) {
    return _repository.startNewGame(difficulty);
  }
}
