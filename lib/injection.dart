import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/ai/block_win_ai_strategy.dart';
import 'data/ai/minimax_ai_strategy.dart';
import 'data/ai/random_ai_strategy.dart';
import 'data/repositories/game_repository_impl.dart';
import 'domain/repositories/ai_strategy.dart';
import 'domain/repositories/game_repository.dart';
import 'domain/use_cases/check_game_over_use_case.dart';
import 'domain/use_cases/get_bot_move_use_case.dart';
import 'domain/use_cases/play_turn_use_case.dart';
import 'domain/use_cases/start_game_use_case.dart';

/// Check game over use case (stateless, singleton).
final checkGameOverUseCaseProvider = Provider<CheckGameOverUseCase>((ref) {
  return CheckGameOverUseCase();
});

/// Game repository (singleton).
final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final checkGameOver = ref.watch(checkGameOverUseCaseProvider);
  return GameRepositoryImpl(checkGameOver);
});

/// AI strategy by difficulty. [difficulty] 1 = random, 2 = block, 3 = minimax.
final aiStrategyProvider = Provider.family<AiStrategy, int>((ref, difficulty) {
  switch (difficulty) {
    case 1:
      return RandomAiStrategy();
    case 2:
      return BlockWinAiStrategy();
    case 3:
      return MinimaxAiStrategy();
    default:
      return RandomAiStrategy();
  }
});

/// Get bot move use case (depends on difficulty for strategy).
final getBotMoveUseCaseProvider = Provider.family<GetBotMoveUseCase, int>((ref, difficulty) {
  final strategy = ref.watch(aiStrategyProvider(difficulty));
  return GetBotMoveUseCase(strategy);
});

/// Start game use case.
final startGameUseCaseProvider = Provider<StartGameUseCase>((ref) {
  final repo = ref.watch(gameRepositoryProvider);
  return StartGameUseCase(repo);
});

/// Play turn use case.
final playTurnUseCaseProvider = Provider<PlayTurnUseCase>((ref) {
  final repo = ref.watch(gameRepositoryProvider);
  return PlayTurnUseCase(repo);
});
