import 'package:tictactoe_betclic/domain/entities/game_result.dart';

import 'difficulty_option.dart';

/// Payload passed when navigating to the end game screen: result and difficulty for "Play again".
class EndGamePayload {
  EndGamePayload({this.result, DifficultyOption? difficulty})
    : difficulty = difficulty ?? DifficultyOption.all.first;

  final GameResult? result;
  final DifficultyOption difficulty;
}
