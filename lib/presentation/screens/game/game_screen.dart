import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe_betclic/core/models/difficulty_option.dart';
import 'package:tictactoe_betclic/core/models/end_game_payload.dart';
import 'package:tictactoe_betclic/core/router/app_router.dart';
import 'package:tictactoe_betclic/core/theme/app_colors.dart';
import 'package:tictactoe_betclic/core/theme/app_spacing.dart';
import 'package:tictactoe_betclic/domain/entities/game_status.dart';
import 'package:tictactoe_betclic/domain/entities/player.dart';
import 'package:tictactoe_betclic/presentation/providers/game_notifier.dart';
import 'package:tictactoe_betclic/presentation/widgets/game_cell.dart';

/// Game screen: 3x3 grid, turn indicator, difficulty. Starts game when [difficulty] is passed via route.
class GameScreen extends ConsumerWidget {
  const GameScreen({super.key, this.difficulty});

  /// Difficulty passed from welcome or end screen. When set, the screen starts the game.
  final DifficultyOption? difficulty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<GameNotifierState>(gameNotifierProvider, (prev, next) {
      final status = next.gameState?.status;
      if (status is GameStatusOver) {
        // Play a haptic feedback when the game is over.
        HapticFeedback.lightImpact();

        final gameState = next.gameState!;
        if (!context.mounted) {
          return;
        }
        context.pushNamed(
          AppRoutes.endGame,
          extra: EndGamePayload(
            result: status.result,
            difficulty: DifficultyOption.forLevel(gameState.difficulty),
          ),
        );
      }
    });

    final notifierState = ref.watch(gameNotifierProvider);
    final gameState = notifierState.gameState;
    final isBotThinking = notifierState.isBotThinking;

    // Start or restart game when difficulty is provided and there's no active game.
    final shouldStart =
        difficulty != null &&
        (gameState == null || gameState.status is GameStatusOver);
    if (shouldStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(gameNotifierProvider.notifier).startGame(difficulty!.level);
      });
    }

    // No game yet, or we're about to start/restart: show loading or "No game started".
    if (gameState == null || shouldStart) {
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
          child: shouldStart
              ? const CircularProgressIndicator(color: AppColors.onBackground)
              : Text(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'TIC TAC TOE',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (isBotThinking)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onBackground,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      turnLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.onBackground,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  turnLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Difficulty: ${DifficultyOption.forLevel(gameState.difficulty).label}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.onBackground),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const gap = 10.0;
                      final side = constraints.maxWidth < constraints.maxHeight
                          ? constraints.maxWidth
                          : constraints.maxHeight;
                      final cellSize = (side - 2 * gap) / 3;
                      return SizedBox(
                        width: side,
                        height: side,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var row = 0; row < 3; row++) ...[
                              if (row > 0) const SizedBox(height: gap),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (var col = 0; col < 3; col++) ...[
                                    if (col > 0) const SizedBox(width: gap),
                                    SizedBox(
                                      width: cellSize,
                                      height: cellSize,
                                      child: GameCell(
                                        player: gameState.board[row * 3 + col],
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
