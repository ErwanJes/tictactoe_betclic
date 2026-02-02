import 'package:flutter/material.dart';

/// Design system colors.
abstract final class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1976D2);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color background = Color(0xFFF5F5F5);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  /// Win (human or positive outcome).
  static const Color semanticWin = Color(0xFF2E7D32);
  /// Lose (negative outcome).
  static const Color semanticLose = Color(0xFFC62828);
  /// Draw.
  static const Color semanticDraw = Color(0xFF757575);
}
