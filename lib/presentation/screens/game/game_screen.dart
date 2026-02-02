import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/difficulty_option.dart';
import '../../../core/router/app_router.dart';
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
        context.pushNamed(AppRoutes.endGame, extra: status.result);
      }
    });

    final gameState = ref.watch(gameNotifierProvider).gameState;
    if (gameState == null) {
      return Scaffold(
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
    final isHumanTurn = gameState.currentPlayer == Player.x && !isOver;
    final winningLine = gameState.winningLine ?? <int>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Tic Tac Toe')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isOver
                    ? 'Game over'
                    : (isHumanTurn ? "Your turn (X)" : "Bot's turn (O)"),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Difficulty: ${DifficultyOption.forLevel(gameState.difficulty).label}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth,
                        child: Column(
                          children: [
                            for (var row = 0; row < 3; row++)
                              Expanded(
                                child: Row(
                                  children: [
                                    for (var col = 0; col < 3; col++) ...[
                                      if (col > 0) const SizedBox(width: 4),
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
