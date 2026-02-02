import 'package:go_router/go_router.dart';

import 'package:tictactoe_betclic/core/models/difficulty_option.dart';
import 'package:tictactoe_betclic/core/models/end_game_payload.dart';
import 'package:tictactoe_betclic/presentation/screens/end_game/end_game_screen.dart';
import 'package:tictactoe_betclic/presentation/screens/game/game_screen.dart';
import 'package:tictactoe_betclic/presentation/screens/welcome/welcome_screen.dart';

/// Route names.
abstract final class AppRoutes {
  static const String welcome = 'welcome';
  static const String game = 'game';
  static const String endGame = 'endGame';
}

/// App router configuration.
class AppRouter {
  AppRouter._();

  static GoRouter create() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: AppRoutes.welcome,
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/game',
          name: AppRoutes.game,
          builder: (context, state) {
            final difficulty = state.extra as DifficultyOption?;
            return GameScreen(difficulty: difficulty);
          },
        ),
        GoRoute(
          path: '/end',
          name: AppRoutes.endGame,
          builder: (context, state) {
            final payload = state.extra as EndGamePayload?;
            return EndGameScreen(payload: payload);
          },
        ),
      ],
    );
  }
}
