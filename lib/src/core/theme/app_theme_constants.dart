import 'package:flutter/material.dart';

class AppColors {
  // ─── Zyvo Brand Palette ───────────────────────────────────────────────────
  static const Color zyvoNavy   = Color(0xFF0A1628);  // Dark navy (always-dark screens)
  static const Color zyvoTeal   = Color(0xFF2EDDC8);  // Primary teal
  static const Color zyvoLime   = Color(0xFF7ED957);  // Lime accent
  static const Color zyvoPurple = Color(0xFF9B72CF);  // Purple accent

  // ─── Light Mode ──────────────────────────────────────────────────────────
  static const Color backgroundColor      = Color(0xFFF0F7FF);  // Light blue-tinted bg
  static const Color backgroundSecondary  = Color(0xFFF8FAFF);
  static const Color surfaceColor         = Color(0xFFFFFFFF);  // White cards
  static const Color surfaceBorder        = Color(0xFFE8EEFF);

  static const Color textColor            = Color(0xFF0F1E3C);  // Dark navy text
  static const Color textColorLight       = Color(0xFF94A3B8);
  static const Color textColorMuted       = Color(0xFF64748B);
  static const Color borderColor          = Color(0xFFE2E8F0);
  static const Color dividerColor         = Color(0xFFF1F5F9);

  // Primary → Zyvo Teal
  static const Color primaryColor  = Color(0xFF2EDDC8);
  static const Color primaryDark   = Color(0xFF1CB8A5);
  static const Color primaryLight  = Color(0xFFE0FAF7);
  static const Color primaryMuted  = Color(0xFFB0F2EB);

  // Status: Normal (Green)
  static const Color successColor  = Color(0xFF059669);
  static const Color successBg     = Color(0xFFECFDF5);
  static const Color successText   = Color(0xFF065F46);

  // Status: Caution (Orange)
  static const Color warningColor  = Color(0xFFD97706);
  static const Color warningBg     = Color(0xFFFFFBEB);
  static const Color warningText   = Color(0xFF92400E);

  // Status: Danger (Red)
  static const Color errorColor    = Color(0xFFDC2626);
  static const Color errorBg       = Color(0xFFFEF2F2);
  static const Color errorText     = Color(0xFF991B1B);

  static const Color infoColor     = Color(0xFF3B82F6);
  static const Color shadowColor   = Color(0x1A000000);

  // ─── Accent / Category Colors ────────────────────────────────────────────
  static const Color avatarBlue       = Color(0xFF2563EB);
  static const Color avatarBlueLight  = Color(0xFF3B82F6);
  static const Color accentPurple     = Color(0xFF7C3AED);
  static const Color accentOrange     = Color(0xFFF97316);
  static const Color errorAlt         = Color(0xFFEF4444);
  static const Color tanAccent        = Color(0xFFD4B896);

  // Light-mode fill / hint variants
  static const Color fillLight        = Color(0xFFF8FAFC);
  static const Color hintColor        = Color(0xFF94A3B8);
  static const Color placeholderGray  = Color(0xFFB0BAC5);

  // ─── Dark Mode ───────────────────────────────────────────────────────────
  static const Color darkBackgroundColor      = Color(0xFF0A1628);  // Zyvo navy
  static const Color darkBackgroundSecondary  = Color(0xFF0D1E35);
  static const Color darkSurfaceColor         = Color(0xFF182030);
  static const Color darkSurfaceColor2        = Color(0xFF1E2E44);
  static const Color darkBorderColor          = Color(0xFF243350);
  static const Color darkTextColor            = Color(0xFFEEF2FF);
  static const Color darkTextColorMuted       = Color(0xFF8899BB);
  static const Color darkTextColorLight       = Color(0xFF64748B);
  static const Color darkPrimaryContainer     = Color(0xFF1B3A4B);
  static const Color darkNavyGradientEnd      = Color(0xFF112244);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}

class AppRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
}

class AppTypography {
  static const String fontFamily = 'Poppins';

  // Display Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
}
