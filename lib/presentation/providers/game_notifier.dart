import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/entities.dart';
import '../../domain/use_cases/play_turn_use_case.dart';
import '../../domain/use_cases/start_game_use_case.dart';
import '../../injection.dart';

/// State exposed to the UI: current game or null (before starting or after reset).
class GameNotifierState {
  const GameNotifierState({this.gameState});

  final GameState? gameState;

  bool get hasGame => gameState != null;
}

/// Notifier that holds game state and orchestrates human + bot moves.
class GameNotifier extends Notifier<GameNotifierState> {
  @override
  GameNotifierState build() => const GameNotifierState();

  StartGameUseCase get _startGame => ref.read(startGameUseCaseProvider);
  PlayTurnUseCase get _playTurn => ref.read(playTurnUseCaseProvider);

  void startGame(int difficulty) {
    final gameState = _startGame(difficulty);
    state = GameNotifierState(gameState: gameState);
  }

  void playAt(int index) {
    final current = state.gameState;
    if (current == null) return;
    if (current.status is GameStatusOver) return;
    // Human is X. Only accept human move when it's X's turn.
    if (current.currentPlayer != Player.x) return;

    try {
      final newGameState = _playTurn(index);
      state = GameNotifierState(gameState: newGameState);

      // If game not over and it's O's turn, bot plays.
      if (newGameState.status is GameStatusPlaying && newGameState.currentPlayer == Player.o) {
        _scheduleBotMove(newGameState.difficulty, newGameState.board);
      }
    } catch (_) {
      // Invalid move: ignore or could show snackbar via a separate channel
    }
  }

  void _scheduleBotMove(int difficulty, List<Player?> board) {
    Future.microtask(() {
      final getBotMove = ref.read(getBotMoveUseCaseProvider(difficulty));
      final botIndex = getBotMove(board, Player.o);
      final newGameState = _playTurn(botIndex);
      state = GameNotifierState(gameState: newGameState);
    });
  }

  void playAgain() {
    state = const GameNotifierState();
  }
}

final gameNotifierProvider = NotifierProvider<GameNotifier, GameNotifierState>(GameNotifier.new);
