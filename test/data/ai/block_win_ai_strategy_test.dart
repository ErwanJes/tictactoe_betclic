import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_betclic/data/ai/block_win_ai_strategy.dart';
import 'package:tictactoe_betclic/domain/entities/player.dart';

void main() {
  late BlockWinAiStrategy strategy;

  setUp(() {
    strategy = BlockWinAiStrategy();
  });

  test('blocks X from winning in first row', () {
    final board = <Player?>[
      Player.x, Player.x, null,
      null, Player.o, null,
      null, null, null,
    ];
    final move = strategy.getMove(board, Player.o);
    expect(move, 2);
  });

  test('takes win when O has two in a column', () {
    final board = <Player?>[
      Player.o, Player.x, null,
      Player.o, null, null,
      null, null, null,
    ];
    final move = strategy.getMove(board, Player.o);
    expect(move, 6);
  });
}
