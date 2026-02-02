import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_betclic/core/models/end_game_payload.dart';
import 'package:tictactoe_betclic/core/router/app_router.dart';
import 'package:tictactoe_betclic/core/theme/app_colors.dart';
import 'package:tictactoe_betclic/core/theme/app_spacing.dart';
import 'package:tictactoe_betclic/domain/entities/game_result.dart';
import 'package:tictactoe_betclic/presentation/widgets/app_primary_button.dart';

/// End game screen: result message (win/lose/draw), Play again button.
class EndGameScreen extends ConsumerWidget {
  const EndGameScreen({super.key, this.payload});

  final EndGamePayload? payload;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (message, color) = _messageAndColor(payload?.result);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                    message,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: color),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                    curve: Curves.easeOut,
                  ),
              const SizedBox(height: AppSpacing.lg),
              AppPrimaryButton(
                    label: 'Play again',
                    onPressed: () {
                      context.goNamed(AppRoutes.welcome);
                    },
                    semanticsLabel: 'Play again',
                  )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 150.ms)
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                    curve: Curves.easeOut,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  (String, Color) _messageAndColor(GameResult? gameResult) {
    if (gameResult == null) {
      return ('Game over', AppColors.onBackground);
    }
    return switch (gameResult) {
      GameResult.humanWin => ('You win!', AppColors.semanticWin),
      GameResult.botWin => ('You lose', AppColors.semanticLose),
      GameResult.draw => ("It's a draw", AppColors.semanticDraw),
    };
  }
}
