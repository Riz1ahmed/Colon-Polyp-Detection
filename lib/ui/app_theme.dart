import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF0B1119);
  static const surface = Color(0xFF141E2A);
  static const border = Color(0xFF29394A);
  static const mint = Color(0xFF74E6BE);
}

abstract final class AppTheme {
  static ThemeData get dark {
    final colors =
        ColorScheme.fromSeed(
          seedColor: AppColors.mint,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.mint,
          onPrimary: const Color(0xFF10251D),
          surface: AppColors.surface,
          onSurface: const Color(0xFFF0F5FA),
          onSurfaceVariant: const Color(0xFFAFBDCB),
        );
    final theme = ThemeData(colorScheme: colors, useMaterial3: true);

    return theme.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      textTheme: theme.textTheme.copyWith(
        headlineMedium: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
        ),
        titleMedium: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
