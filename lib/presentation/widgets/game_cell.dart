import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_spacing.dart';
import '../../domain/entities/player.dart';

/// A single cell in the 3x3 grid. Shows X or O and handles tap when empty and enabled.
class GameCell extends StatelessWidget {
  const GameCell({
    super.key,
    required this.player,
    required this.onTap,
    this.enabled = true,
    this.highlight = false,
  });

  final Player? player;
  final VoidCallback? onTap;
  final bool enabled;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final canTap = player == null && enabled;
    return Semantics(
      button: true,
      enabled: canTap,
      label: player == null ? 'Empty cell' : 'Cell with ${player == Player.x ? 'X' : 'O'}',
      child: GestureDetector(
        onTap: canTap ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: highlight ? Theme.of(context).colorScheme.primaryContainer : null,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Center(
            child: _Symbol(player: player)
                .animate()
                .fadeIn(duration: 200.ms)
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), curve: Curves.easeOut),
          ),
        ),
      ),
    );
  }
}

class _Symbol extends StatelessWidget {
  const _Symbol({this.player});

  final Player? player;

  @override
  Widget build(BuildContext context) {
    if (player == null) return const SizedBox.shrink();
    final isX = player == Player.x;
    return Text(
      isX ? 'X' : 'O',
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isX ? Colors.blue : Colors.red,
          ),
    );
  }
}
