import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/game_result.dart';
import '../../providers/game_notifier.dart';
import '../../widgets/app_primary_button.dart';

/// End game screen: result message (win/lose/draw), Play again button.
class EndGameScreen extends ConsumerWidget {
  const EndGameScreen({super.key, this.result});

  final GameResult? result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (message, color) = _messageAndColor(result);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), curve: Curves.easeOut),
              const SizedBox(height: AppSpacing.lg),
              AppPrimaryButton(
                label: 'Play again',
                onPressed: () {
                  ref.read(gameNotifierProvider.notifier).playAgain();
                  context.goNamed(AppRoutes.welcome);
                },
                semanticsLabel: 'Play again',
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 150.ms)
                  .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), curve: Curves.easeOut),
            ],
          ),
        ),
      ),
    );
  }

  (String, Color) _messageAndColor(GameResult? r) {
    if (r == null) return ('Game over', AppColors.onBackground);
    return switch (r) {
      GameResult.humanWin => ('You win!', AppColors.semanticWin),
      GameResult.botWin => ('You lose', AppColors.semanticLose),
      GameResult.draw => ("It's a draw", AppColors.semanticDraw),
    };
  }
}
