import '../entities/game_state.dart';
import '../repositories/game_repository.dart';

/// Starts a new game with the given difficulty and returns initial state.
class StartGameUseCase {
  StartGameUseCase(this._repository);

  final GameRepository _repository;

  GameState call(int difficulty) {
    return _repository.startNewGame(difficulty);
  }
}
