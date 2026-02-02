import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_betclic/domain/entities/entities.dart';
import 'package:tictactoe_betclic/domain/use_cases/check_game_over_use_case.dart';

void main() {
  late CheckGameOverUseCase useCase;

  setUp(() {
    useCase = CheckGameOverUseCase();
  });

  test('returns null when board is empty', () {
    final board = List<Player?>.filled(9, null);
    final (result, line) = useCase(board);
    expect(result, isNull);
    expect(line, isNull);
  });

  test('returns humanWin and line when X wins in first row', () {
    final board = <Player?>[
      Player.x, Player.x, Player.x,
      null, null, null,
      null, null, null,
    ];
    final (result, line) = useCase(board);
    expect(result, GameResult.humanWin);
    expect(line, [0, 1, 2]);
  });

  test('returns botWin and line when O wins in diagonal', () {
    final board = <Player?>[
      Player.o, Player.x, Player.x,
      null, Player.o, null,
      null, null, Player.o,
    ];
    final (result, line) = useCase(board);
    expect(result, GameResult.botWin);
    expect(line, [0, 4, 8]);
  });

  test('returns draw when board is full with no winner', () {
    final board = <Player?>[
      Player.x, Player.o, Player.x,
      Player.x, Player.o, Player.o,
      Player.o, Player.x, Player.x,
    ];
    final (result, line) = useCase(board);
    expect(result, GameResult.draw);
    expect(line, isNull);
  });

  test('returns null when game is still in progress', () {
    final board = <Player?>[
      Player.x, Player.o, null,
      null, Player.x, null,
      null, null, null,
    ];
    final (result, line) = useCase(board);
    expect(result, isNull);
    expect(line, isNull);
  });
}
