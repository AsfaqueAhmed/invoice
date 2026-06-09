import 'package:flutter/material.dart';

// ─── Abstract base class ─────────────────────────────────────────
abstract class AppColorBase {
  // Brand
  Color get primary;
  Color get primaryLight;
  Color get primaryDark;
  Color get primaryContainer;
  Color get onPrimary;
  Color get onPrimaryContainer;

  // Secondary
  Color get secondary;
  Color get secondaryContainer;
  Color get onSecondary;
  Color get onSecondaryContainer;

  // Tertiary
  Color get tertiary;
  Color get tertiaryContainer;
  Color get onTertiary;
  Color get onTertiaryContainer;

  // Surface / Background
  Color get scaffold;
  Color get surface;
  Color get surfaceDim;
  Color get surfaceContainer;
  Color get surfaceContainerLow;
  Color get surfaceContainerHigh;
  Color get surfaceContainerLowest;
  Color get cardBg;

  // On-surface
  Color get onSurface;
  Color get onSurfaceVariant;

  // Text
  Color get textPrimary;
  Color get textSecondary;
  Color get textTertiary;

  // Outline
  Color get outline;
  Color get outlineVariant;

  // Semantic
  Color get success;
  Color get successBg;
  Color get successText;
  Color get warning;
  Color get warningBg;
  Color get warningText;
  Color get error;
  Color get errorContainer;
  Color get onError;

  // Status chips
  Color get chipBlueBg;
  Color get chipBlueFg;
  Color get chipGreenBg;
  Color get chipGreenFg;
  Color get chipRedBg;
  Color get chipRedFg;
  Color get chipAmberBg;
  Color get chipAmberFg;
  Color get chipGrayBg;
  Color get chipGrayFg;

  // Stock status
  Color get inStock;
  Color get lowStock;
  Color get outOfStock;

  // Neutral
  Color get white;
  Color get black;
}

// ─── Light Theme Implementation ──────────────────────────────────
class LightColors implements AppColorBase {
  const LightColors._();

  static const LightColors instance = LightColors._();

  @override
  Color get primary => const Color(0xFF4F46E5);
  @override
  Color get primaryLight => const Color(0xFF818CF8);
  @override
  Color get primaryDark => const Color(0xFF3730A3);
  @override
  Color get primaryContainer => const Color(0xFFEEF2FF);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);
  @override
  Color get onPrimaryContainer => const Color(0xFF3730A3);

  @override
  Color get secondary => const Color(0xFF505F76);
  @override
  Color get secondaryContainer => const Color(0xFFD0E1FB);
  @override
  Color get onSecondary => const Color(0xFFFFFFFF);
  @override
  Color get onSecondaryContainer => const Color(0xFF0B1C30);

  @override
  Color get tertiary => const Color(0xFF943700);
  @override
  Color get tertiaryContainer => const Color(0xFFFFDBCD);
  @override
  Color get onTertiary => const Color(0xFFFFFFFF);
  @override
  Color get onTertiaryContainer => const Color(0xFF360F00);

  @override
  Color get scaffold => const Color(0xFFF9FAFB);
  @override
  Color get surface => const Color(0xFFFAF8FF);
  @override
  Color get surfaceDim => const Color(0xFFD9D9E5);
  @override
  Color get surfaceContainer => const Color(0xFFEDEDF9);
  @override
  Color get surfaceContainerLow => const Color(0xFFF3F3FE);
  @override
  Color get surfaceContainerHigh => const Color(0xFFE7E7F3);
  @override
  Color get surfaceContainerLowest => const Color(0xFFFFFFFF);
  @override
  Color get cardBg => const Color(0xFFFFFFFF);

  @override
  Color get onSurface => const Color(0xFF191B23);
  @override
  Color get onSurfaceVariant => const Color(0xFF434655);

  @override
  Color get textPrimary => const Color(0xFF1A1A2E);
  @override
  Color get textSecondary => const Color(0xFF6B7280);
  @override
  Color get textTertiary => const Color(0xFF9CA3AF);

  @override
  Color get outline => const Color(0xFF737686);
  @override
  Color get outlineVariant => const Color(0xFFC3C6D7);

  @override
  Color get success => const Color(0xFF10B981);
  @override
  Color get successBg => const Color(0xFFD1FAE5);
  @override
  Color get successText => const Color(0xFF047857);
  @override
  Color get warning => const Color(0xFFF59E0B);
  @override
  Color get warningBg => const Color(0xFFFFF8E1);
  @override
  Color get warningText => const Color(0xFFF57F17);
  @override
  Color get error => const Color(0xFFEF4444);
  @override
  Color get errorContainer => const Color(0xFFFFDAD6);
  @override
  Color get onError => const Color(0xFFFFFFFF);

  @override
  Color get chipBlueBg => const Color(0xFFEEF2FF);
  @override
  Color get chipBlueFg => const Color(0xFF5B4CF5);
  @override
  Color get chipGreenBg => const Color(0xFFECFDF5);
  @override
  Color get chipGreenFg => const Color(0xFF059669);
  @override
  Color get chipRedBg => const Color(0xFFFEF2F2);
  @override
  Color get chipRedFg => const Color(0xFFDC2626);
  @override
  Color get chipAmberBg => const Color(0xFFFFFBEB);
  @override
  Color get chipAmberFg => const Color(0xFFD97706);
  @override
  Color get chipGrayBg => const Color(0xFFF3F4F6);
  @override
  Color get chipGrayFg => const Color(0xFF6B7280);

  @override
  Color get inStock => const Color(0xFF10B981);
  @override
  Color get lowStock => const Color(0xFFF59E0B);
  @override
  Color get outOfStock => const Color(0xFFEF4444);

  @override
  Color get white => const Color(0xFFFFFFFF);
  @override
  Color get black => const Color(0xFF000000);
}

// ─── Dark Theme Implementation ───────────────────────────────────
class DarkColors implements AppColorBase {
  const DarkColors._();

  static const DarkColors instance = DarkColors._();

  @override
  Color get primary => const Color(0xFF818CF8);
  @override
  Color get primaryLight => const Color(0xFFB4C5FF);
  @override
  Color get primaryDark => const Color(0xFF4F46E5);
  @override
  Color get primaryContainer => const Color(0xFF3730A3);
  @override
  Color get onPrimary => const Color(0xFF1A1A2E);
  @override
  Color get onPrimaryContainer => const Color(0xFFEEF2FF);

  @override
  Color get secondary => const Color(0xFFB7C8E1);
  @override
  Color get secondaryContainer => const Color(0xFF374151);
  @override
  Color get onSecondary => const Color(0xFF0B1C30);
  @override
  Color get onSecondaryContainer => const Color(0xFFD3E4FE);

  @override
  Color get tertiary => const Color(0xFFFFB596);
  @override
  Color get tertiaryContainer => const Color(0xFF5C2200);
  @override
  Color get onTertiary => const Color(0xFF360F00);
  @override
  Color get onTertiaryContainer => const Color(0xFFFFDBCD);

  @override
  Color get scaffold => const Color(0xFF111827);
  @override
  Color get surface => const Color(0xFF0F172A);
  @override
  Color get surfaceDim => const Color(0xFF1A1D27);
  @override
  Color get surfaceContainer => const Color(0xFF1F2937);
  @override
  Color get surfaceContainerLow => const Color(0xFF1A2233);
  @override
  Color get surfaceContainerHigh => const Color(0xFF374151);
  @override
  Color get surfaceContainerLowest => const Color(0xFF111827);
  @override
  Color get cardBg => const Color(0xFF1F2937);

  @override
  Color get onSurface => const Color(0xFFF9FAFB);
  @override
  Color get onSurfaceVariant => const Color(0xFFD1D5DB);

  @override
  Color get textPrimary => const Color(0xFFF9FAFB);
  @override
  Color get textSecondary => const Color(0xFF9CA3AF);
  @override
  Color get textTertiary => const Color(0xFF6B7280);

  @override
  Color get outline => const Color(0xFF6B7280);
  @override
  Color get outlineVariant => const Color(0xFF374151);

  @override
  Color get success => const Color(0xFF34D399);
  @override
  Color get successBg => const Color(0xFF064E3B);
  @override
  Color get successText => const Color(0xFF6EE7B7);
  @override
  Color get warning => const Color(0xFFFBBF24);
  @override
  Color get warningBg => const Color(0xFF451A03);
  @override
  Color get warningText => const Color(0xFFFCD34D);
  @override
  Color get error => const Color(0xFFF87171);
  @override
  Color get errorContainer => const Color(0xFF7F1D1D);
  @override
  Color get onError => const Color(0xFF1A1A2E);

  @override
  Color get chipBlueBg => const Color(0xFF1E1B4B);
  @override
  Color get chipBlueFg => const Color(0xFF818CF8);
  @override
  Color get chipGreenBg => const Color(0xFF064E3B);
  @override
  Color get chipGreenFg => const Color(0xFF6EE7B7);
  @override
  Color get chipRedBg => const Color(0xFF7F1D1D);
  @override
  Color get chipRedFg => const Color(0xFFFCA5A5);
  @override
  Color get chipAmberBg => const Color(0xFF451A03);
  @override
  Color get chipAmberFg => const Color(0xFFFCD34D);
  @override
  Color get chipGrayBg => const Color(0xFF374151);
  @override
  Color get chipGrayFg => const Color(0xFF9CA3AF);

  @override
  Color get inStock => const Color(0xFF34D399);
  @override
  Color get lowStock => const Color(0xFFFBBF24);
  @override
  Color get outOfStock => const Color(0xFFF87171);

  @override
  Color get white => const Color(0xFFFFFFFF);
  @override
  Color get black => const Color(0xFF000000);
}

// ─── Static access (legacy compat) ───────────────────────────────
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color secondary = Color(0xFF06B6D4);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);
  static const Color background = Color(0xFFF8F7FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color overdue = Color(0xFFEF4444);
  static const Color paid = Color(0xFF10B981);
  static const Color pending = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color scaffoldLight = Color(0xFFF9FAFB);
  static const Color scaffoldDark = Color(0xFF111827);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1F2937);
}

// ─── Helper extension for BuildContext access ─────────────────────
extension AppColorsContext on BuildContext {
  AppColorBase get appColors {
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return isDark ? DarkColors.instance : LightColors.instance;
  }
}
