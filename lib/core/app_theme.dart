import 'package:flutter/material.dart';
import 'app_constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.warmBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.waterBlue,
        surface: AppColors.surfaceOverlay,
        error: AppColors.woundRed,
      ),
      fontFamily: 'Roboto', // Fallback cleanly on Android
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.warmBg.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 6,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
