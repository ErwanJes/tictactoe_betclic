import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Design system theme.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.background,
      ),
      textTheme: _textTheme,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      headlineLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.onSurface,
      ),
      headlineMedium: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
      bodyLarge: const TextStyle(fontSize: 16, color: AppColors.onSurface),
      bodyMedium: const TextStyle(fontSize: 14, color: AppColors.onSurface),
      labelLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
      ),
    );
  }
}
