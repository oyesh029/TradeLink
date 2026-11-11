import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary & Secondary
  static const Color deepNavy = Color(0xFF0B2545);
  static const Color primaryNavy = Color(0xFF0B2545);
  static const Color tradeTeal = Color(0xFF13A89E);
  static const Color gold = Color(0xFFF2A541);
  static const Color successGreen = Color(0xFF2EAA64);
  static const Color alertRed = Color(0xFFE25555);
  static const Color oceanBlue = Color(0xFF3C78E6);
  static const Color infoBlue = Color(0xFF3C78E6);

  // Backgrounds & Neutrals
  static const Color canvasLight = Color(0xFFF8F9FC);
  static const Color cardLight = Colors.white;
  static const Color canvasDark = Color(0xFF0B132B);
  static const Color cardDark = Color(0xFF1C2541);
  static const Color surfaceDark = Color(0xFF131A2E);
  static const Color cardBackgroundDark = Color(0xFF1C2541);
  static const Color borderDark = Color(0xFF334155);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color warningAmber = Color(0xFFF59E0B);

  // Text Semantic Colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Accent Tints
  static const Color tealTint = Color(0xFFE6F7F6);
  static const Color goldTint = Color(0xFFFEF6EB);
  static const Color greenTint = Color(0xFFEAF7F0);
  static const Color redTint = Color(0xFFFDF0F0);
  static const Color blueTint = Color(0xFFEEF4FD);
  static const Color navyTint = Color(0xFFE7ECF3);

  // Dynamic context-aware helper methods
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color cardBg(BuildContext context) =>
      isDark(context) ? cardDark : cardLight;

  static Color canvas(BuildContext context) =>
      isDark(context) ? canvasDark : canvasLight;

  static Color surface(BuildContext context) =>
      isDark(context) ? surfaceDark : const Color(0xFFF1F5F9);

  static Color border(BuildContext context) =>
      isDark(context) ? borderDark : borderLight;

  static Color textPri(BuildContext context) =>
      isDark(context) ? textPrimaryDark : deepNavy;

  static Color textSec(BuildContext context) =>
      isDark(context) ? textSecondaryDark : textSecondaryLight;
}

extension TradeThemeX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get canvasColor => isDark ? AppColors.canvasDark : AppColors.canvasLight;
  Color get cardColor => isDark ? AppColors.cardDark : AppColors.cardLight;
  Color get surfaceColor => isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9);
  Color get borderColor => isDark ? AppColors.borderDark : AppColors.borderLight;
  Color get textPrimary => isDark ? AppColors.textPrimaryDark : AppColors.deepNavy;
  Color get textSecondary => isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
}
