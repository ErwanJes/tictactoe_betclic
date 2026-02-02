import 'package:go_router/go_router.dart';

import '../../domain/entities/game_result.dart';
import '../../presentation/screens/end_game/end_game_screen.dart';
import '../../presentation/screens/game/game_screen.dart';
import '../../presentation/screens/welcome/welcome_screen.dart';

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
          builder: (context, state) => const GameScreen(),
        ),
        GoRoute(
          path: '/end',
          name: AppRoutes.endGame,
          builder: (context, state) {
            final result = state.extra as GameResult?;
            return EndGameScreen(result: result);
          },
        ),
      ],
    );
  }
}
