import 'package:tictactoe_betclic/domain/entities/game_state.dart';
import 'package:tictactoe_betclic/domain/entities/game_status.dart';
import 'package:tictactoe_betclic/domain/entities/player.dart';
import 'package:tictactoe_betclic/domain/repositories/game_repository.dart';
import 'package:tictactoe_betclic/domain/use_cases/check_game_over_use_case.dart';

/// In-memory implementation of [GameRepository].
class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl(this._checkGameOver);

  final CheckGameOverUseCase _checkGameOver;

  GameState? _state;

  @override
  GameState? getState() => _state;

  @override
  GameState startNewGame(int difficulty) {
    final board = List<Player?>.filled(9, null);
    _state = GameState(
      board: board,
      currentPlayer: Player.x,
      status: const GameStatusPlaying(),
      difficulty: difficulty,
    );
    return _state!;
  }

  @override
  GameState applyMove(int index) {
    final state = _state;
    if (state == null) {
      throw InvalidMoveException('No game started');
    }
    if (state.status is GameStatusOver) {
      throw InvalidMoveException('Game is over');
    }
    if (index < 0 || index > 8) {
      throw InvalidMoveException('Invalid cell index');
    }
    if (state.board[index] != null) {
      throw InvalidMoveException('Cell already filled');
    }

    final newBoard = List<Player?>.from(state.board)
      ..[index] = state.currentPlayer;
    final (result, winningLine) = _checkGameOver(newBoard);
    final newPlayer = state.currentPlayer.opposite;

    GameStatus newStatus;
    if (result != null) {
      newStatus = GameStatusOver(result);
    } else {
      newStatus = const GameStatusPlaying();
    }

    _state = state.copyWith(
      board: newBoard,
      currentPlayer: newPlayer,
      status: newStatus,
      winningLine: winningLine,
    );
    return _state!;
  }
}
