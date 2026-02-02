import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_betclic/data/ai/minimax_ai_strategy.dart';
import 'package:tictactoe_betclic/domain/entities/player.dart';

void main() {
  late MinimaxAiStrategy strategy;

  setUp(() {
    strategy = MinimaxAiStrategy();
  });

  test('returns valid empty cell when board is empty', () {
    final board = List<Player?>.filled(9, null);
    final move = strategy.getMove(board, Player.o);
    expect(move, inInclusiveRange(0, 8));
    expect(board[move], isNull);
  });

  test('blocks X from winning', () {
    final board = <Player?>[
      Player.x, Player.x, null,
      null, Player.o, null,
      null, null, null,
    ];
    final move = strategy.getMove(board, Player.o);
    expect(move, 2);
  });

  test('takes win when O has two in a row', () {
    final board = <Player?>[
      Player.o, Player.o, null,
      Player.x, Player.x, null,
      null, null, null,
    ];
    final move = strategy.getMove(board, Player.o);
    expect(move, 2);
  });
}
