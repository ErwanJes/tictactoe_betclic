import 'package:flutter/material.dart';
import 'package:tictactoe_betclic/core/theme/app_colors.dart';
import 'package:tictactoe_betclic/core/theme/app_spacing.dart';

const double _buttonRadius = 16;

/// Primary action button using design system colors and typography.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.semanticsLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? label,
      button: true,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.boardCell,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.boardCell.withValues(alpha: 0.6),
          disabledForegroundColor: AppColors.onPrimary.withValues(alpha: 0.6),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          elevation: 0,
        ),
        child: Text(label),
      ),
    );
  }
}
