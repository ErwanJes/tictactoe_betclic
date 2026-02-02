import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_betclic/data/ai/random_ai_strategy.dart';
import 'package:tictactoe_betclic/domain/entities/player.dart';

void main() {
  late RandomAiStrategy strategy;

  setUp(() {
    strategy = RandomAiStrategy();
  });

  test('returns one of the empty cell indices', () {
    final board = <Player?>[
      Player.x, null, Player.o,
      null, null, null,
      null, null, null,
    ];
    final move = strategy.getMove(board, Player.o);
    expect(move, inInclusiveRange(0, 8));
    expect(board[move], isNull);
  });

  test('returns only empty cell when one left', () {
    final board = <Player?>[
      Player.x, Player.o, Player.x,
      Player.o, Player.x, Player.o,
      Player.x, Player.o, null,
    ];
    final move = strategy.getMove(board, Player.x);
    expect(move, 8);
  });
}
