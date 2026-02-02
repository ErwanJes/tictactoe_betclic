import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/difficulty_option.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/game_notifier.dart';
import '../../widgets/game_cell.dart';

/// Game screen: 3x3 grid, turn indicator, difficulty. Navigates to end when game over.
class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<GameNotifierState>(gameNotifierProvider, (prev, next) {
      final status = next.gameState?.status;
      if (status is GameStatusOver) {
        HapticFeedback.lightImpact();
        context.pushNamed(AppRoutes.endGame, extra: status.result);
      }
    });

    final notifierState = ref.watch(gameNotifierProvider);
    final gameState = notifierState.gameState;
    final isBotThinking = notifierState.isBotThinking;

    if (gameState == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.onBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            tooltip: 'Back to welcome',
          ),
        ),
        body: Center(
          child: Text(
            'No game started',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    final notifier = ref.read(gameNotifierProvider.notifier);
    final isOver = gameState.status is GameStatusOver;
    final isHumanTurn =
        gameState.currentPlayer == Player.x && !isOver && !isBotThinking;
    final winningLine = gameState.winningLine ?? <int>[];

    final turnLabel = isOver
        ? 'GAME OVER'
        : isBotThinking
        ? 'BOT IS THINKING…'
        : (isHumanTurn ? 'YOUR TURN' : "BOT'S TURN");

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(gameNotifierProvider.notifier).playAgain();
            context.pop();
          },
          tooltip: 'Back to welcome',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TIC TAC TOE',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.onBackground,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (isBotThinking)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onBackgroundSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      turnLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                )
              else
                Text(turnLabel, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Difficulty: ${DifficultyOption.forLevel(gameState.difficulty).label}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const gap = 12.0;
                      return SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth,
                        child: Column(
                          children: [
                            for (var row = 0; row < 3; row++) ...[
                              if (row > 0) const SizedBox(height: gap),
                              Expanded(
                                child: Row(
                                  children: [
                                    for (var col = 0; col < 3; col++) ...[
                                      if (col > 0) const SizedBox(width: gap),
                                      Expanded(
                                        child: GameCell(
                                          player:
                                              gameState.board[row * 3 + col],
                                          onTap: () =>
                                              notifier.playAt(row * 3 + col),
                                          enabled: isHumanTurn,
                                          highlight: winningLine.contains(
                                            row * 3 + col,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
