import 'package:flutter/material.dart';

/// Design system colors (neumorphic dark theme).
abstract final class AppColors {
  AppColors._();

  /// Dark indigo background (main canvas).
  static const Color background = Color(0xFF2E2A66);

  /// Violet-blue for board cells and primary interactive surfaces.
  static const Color boardCell = Color(0xFF4A458B);

  /// Lighter edge for 3D cell highlight (top-left).
  static const Color cellInnerHighlight = Color(0xFF6B65B3);

  /// Darker edge for 3D cell shadow (bottom-right).
  static const Color cellInnerShadow = Color(0xFF3D3877);

  /// Dark band at bottom of cell for depth (design: bottom shadow).
  static const Color cellBottomShadow = Color(0xFF312864);

  /// Primary text (titles).
  static const Color onBackground = Color(0xFFFFFFFF);

  /// Secondary text (subtitles, hints).
  static const Color onBackgroundSecondary = Color(0xFFD4D4D4);

  // Legacy / semantic (used on dark background)
  static const Color primary = Color(0xFF4A458B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFF4A458B);
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFFD4D4D4);

  /// Win (human or positive outcome).
  static const Color semanticWin = Color(0xFF81C784);

  /// Lose (negative outcome).
  static const Color semanticLose = Color(0xFFE57373);

  /// Draw.
  static const Color semanticDraw = Color(0xFFB0B0B0);
}
