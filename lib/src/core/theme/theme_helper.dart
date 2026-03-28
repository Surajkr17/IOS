import 'package:flutter/material.dart';
import 'app_theme_constants.dart';

/// Extension on [BuildContext] that resolves light/dark adaptive colors
/// in a single place, removing the repeated `isDark ? … : …` boilerplate
/// from every screen.
extension ThemeHelper on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // ── Backgrounds ──────────────────────────────────────────────────────────
  Color get bg      => isDark ? AppColors.darkBackgroundColor : AppColors.backgroundColor;
  Color get surface => isDark ? AppColors.darkSurfaceColor    : AppColors.surfaceColor;
  Color get surface2 => isDark ? AppColors.darkSurfaceColor2  : AppColors.fillLight;

  // ── Borders / Dividers ───────────────────────────────────────────────────
  Color get border  => isDark ? AppColors.darkBorderColor : AppColors.borderColor;
  Color get divider => isDark ? AppColors.darkBorderColor : AppColors.dividerColor;

  // ── Text ─────────────────────────────────────────────────────────────────
  Color get textH => isDark ? AppColors.darkTextColor        : AppColors.textColor;
  Color get textM => isDark ? AppColors.darkTextColorMuted   : AppColors.textColorMuted;
  Color get textL => isDark ? AppColors.darkTextColorLight   : AppColors.textColorLight;
  Color get hint  => isDark ? AppColors.darkTextColorLight   : AppColors.hintColor;

  // ── Primary variants ─────────────────────────────────────────────────────
  Color get primBg   => isDark ? AppColors.darkPrimaryContainer : AppColors.primaryLight;
  Color get primBord => isDark ? AppColors.primaryDark          : AppColors.primaryMuted;

  // ── Card background (white in light mode) ────────────────────────────────
  Color get cardBg => isDark ? AppColors.darkSurfaceColor : Colors.white;
}
