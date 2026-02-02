import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/player.dart';
import '../../gen/assets.gen.dart';

/// Cell: rounded with inner shadow (x=0, y=-6).
const double _cellRadius = 16;

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
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              // Cell background
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: highlight
                      ? AppColors.cellInnerHighlight.withValues(alpha: 0.4)
                      : AppColors.boardCell,
                  borderRadius: BorderRadius.circular(_cellRadius),
                ),
              ),
              // Inner shadow: x=0, y=-6 (darker at top, soft edge)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_cellRadius),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(0, -1),
                        end: const Alignment(0, 1),
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.black.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.35],
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
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
            ],
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
    if (player == null) {
      return const SizedBox.shrink();
    }
    final icon = player == Player.x
        ? Assets.images.icons.cross
        : Assets.images.icons.circle;
    return icon.svg(width: 48, height: 48);
  }
}
