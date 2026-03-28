import 'package:flutter/material.dart';
import 'app_theme_constants.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Poppins',

      colorScheme: const ColorScheme.light(
        primary: AppColors.zyvoTeal,
        onPrimary: AppColors.zyvoNavy,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.zyvoNavy,
        secondary: AppColors.zyvoLime,
        onSecondary: AppColors.zyvoNavy,
        tertiary: AppColors.zyvoPurple,
        error: AppColors.errorColor,
        surface: AppColors.surfaceColor,
        onSurface: AppColors.textColor,
        surfaceContainerHighest: AppColors.backgroundColor,
        outline: AppColors.borderColor,
        shadow: AppColors.shadowColor,
      ),

      scaffoldBackgroundColor: AppColors.backgroundColor,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceColor,
        foregroundColor: AppColors.textColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineLarge,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.zyvoTeal,
          foregroundColor: AppColors.zyvoNavy,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          textStyle: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.zyvoTeal,
          side: const BorderSide(
            color: AppColors.zyvoTeal,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          textStyle: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.dividerColor,
        contentPadding: const EdgeInsets.all(AppSpacing.lg),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(
            color: AppColors.zyvoTeal,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 2,
          ),
        ),
        labelStyle: AppTypography.labelLarge.copyWith(
          color: AppColors.textColorLight,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textColorLight,
        ),
        errorStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.errorColor,
        ),
      ),

      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceColor,
        selectedItemColor: AppColors.zyvoTeal,
        unselectedItemColor: AppColors.textColorLight,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.zyvoTeal,
        onPrimary: AppColors.zyvoNavy,
        primaryContainer: AppColors.darkPrimaryContainer,
        onPrimaryContainer: AppColors.zyvoTeal,
        secondary: AppColors.zyvoLime,
        onSecondary: AppColors.zyvoNavy,
        tertiary: AppColors.zyvoPurple,
        error: AppColors.errorColor,
        surface: AppColors.darkSurfaceColor,
        onSurface: AppColors.darkTextColor,
        surfaceContainerHighest: AppColors.darkBackgroundColor,
        outline: AppColors.darkBorderColor,
      ),

      scaffoldBackgroundColor: AppColors.darkBackgroundColor,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurfaceColor,
        foregroundColor: AppColors.darkTextColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineLarge,
      ),

      cardTheme: CardThemeData(
        color: AppColors.darkSurfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.darkBorderColor, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.zyvoTeal,
          foregroundColor: AppColors.zyvoNavy,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          textStyle: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkBackgroundColor,
        contentPadding: const EdgeInsets.all(AppSpacing.lg),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.darkBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.darkBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColors.zyvoTeal, width: 1.5),
        ),
        labelStyle: AppTypography.labelLarge.copyWith(color: AppColors.darkTextColorLight),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.darkTextColorLight),
      ),

      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurfaceColor,
        selectedItemColor: AppColors.zyvoTeal,
        unselectedItemColor: AppColors.darkTextColorLight,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
