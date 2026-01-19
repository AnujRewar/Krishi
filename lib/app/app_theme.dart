import 'package:flutter/material.dart';

class AppColors {
  // Primary colors with high contrast for color blindness
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryDarkGreen = Color(0xFF1B5E20);
  static const Color primaryLightGreen = Color(0xFF4CAF50);
  
  // Secondary colors using patterns and icons for differentiation
  static const Color secondaryBrown = Color(0xFF795548);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentBlue = Color(0xFF2196F3);
  
  // Neutral colors with sufficient contrast
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF212121);
  static const Color onSurfaceVariant = Color(0xFF666666);
  
  // Semantic colors
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryGreen,
        secondary: AppColors.secondaryBrown,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.onSurfaceVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
        labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLightGreen,
        secondary: AppColors.accentOrange,
        surface: Color(0xFF1E1E1E),
        onSurface: Color(0xFFFFFFFF),
      ),
      // ... same text theme adaptations for dark mode
    );
  }
}