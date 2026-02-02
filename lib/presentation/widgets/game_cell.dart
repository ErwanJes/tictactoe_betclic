import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/player.dart';
import '../../gen/assets.gen.dart';

/// Neumorphic cell 3D: inner shadow offset (0, -2) and light blur.
const double _cellRadius = 16;
const double _innerShadowBlur = 6;

/// A single cell in the 3x3 grid. Shows cross or circle icon and handles tap when empty and enabled.
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
      label: player == null
          ? 'Empty cell'
          : 'Cell with ${player == Player.x ? 'X' : 'O'}',
      child: GestureDetector(
        onTap: canTap ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: highlight
                ? AppColors.cellInnerHighlight.withValues(alpha: 0.4)
                : AppColors.boardCell,
            borderRadius: BorderRadius.circular(_cellRadius),
            boxShadow: [
              // Inner shadow effect: top highlight (y = -2), light blur
              BoxShadow(
                color: AppColors.cellInnerHighlight.withValues(alpha: 0.4),
                offset: const Offset(0, -2),
                blurRadius: _innerShadowBlur,
                spreadRadius: 0,
              ),
              // Bottom-right shadow for debossed look
              BoxShadow(
                color: AppColors.cellInnerShadow.withValues(alpha: 0.8),
                offset: const Offset(0, 2),
                blurRadius: _innerShadowBlur,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Center(
            child: _Symbol(player: player)
                .animate()
                .fadeIn(duration: 200.ms)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  curve: Curves.easeOut,
                ),
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
    final icon = player == Player.x
        ? Assets.images.icons.cross
        : Assets.images.icons.circle;
    return icon.svg(width: 48, height: 48);
  }
}
