import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_betclic/data/repositories/game_repository_impl.dart';
import 'package:tictactoe_betclic/domain/entities/entities.dart';
import 'package:tictactoe_betclic/domain/repositories/game_repository.dart';
import 'package:tictactoe_betclic/domain/use_cases/check_game_over_use_case.dart';

void main() {
  late GameRepository repo;

  setUp(() {
    repo = GameRepositoryImpl(CheckGameOverUseCase());
  });

  test('getState returns null initially', () {
    expect(repo.getState(), isNull);
  });

  test('startNewGame returns initial state with empty board', () {
    final state = repo.startNewGame(1);
    expect(state.board, everyElement(isNull));
    expect(state.currentPlayer, Player.x);
    expect(state.status, isA<GameStatusPlaying>());
    expect(state.difficulty, 1);
  });

  test('applyMove updates board and switches player', () {
    repo.startNewGame(1);
    final state = repo.applyMove(0);
    expect(state.board[0], Player.x);
    expect(state.currentPlayer, Player.o);
  });

  test('applyMove throws when cell is already filled', () {
    repo.startNewGame(1);
    repo.applyMove(0);
    expect(() => repo.applyMove(0), throwsA(isA<InvalidMoveException>()));
  });

  test('applyMove detects win', () {
    repo.startNewGame(1);
    repo.applyMove(0); // X
    repo.applyMove(3); // O
    repo.applyMove(1); // X
    repo.applyMove(4); // O
    final state = repo.applyMove(2); // X wins first row
    expect(state.status, isA<GameStatusOver>());
    expect((state.status as GameStatusOver).result, GameResult.humanWin);
    expect(state.winningLine, [0, 1, 2]);
  });
}
