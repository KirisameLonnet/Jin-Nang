import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: AppFonts.english, 
      fontFamilyFallback: const [AppFonts.chinese],
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandPurple,
        primary: AppColors.brandPurple,
        surface: AppColors.scaffoldBackground,
        error: AppColors.semanticRed,
        onSurface: AppColors.neutralGray05,
      ),
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      useMaterial3: true,
      textTheme: const TextTheme(
        // Mapping roughly to Figma 'H Primary'
        displayLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 48,
          height: 1,
          letterSpacing: 0.5,
          color: AppColors.neutralGray05,
        ),
        // Mapping roughly to Figma 'H2'
        titleLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          height: 1.2,
          color: AppColors.neutralGray05,
        ),
        // Additional typography can be mapped here as needed
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: AppColors.neutralGray05,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.neutralGray04,
        ),
      ),
    );
  }
}