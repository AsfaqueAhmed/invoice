import 'package:flutter/material.dart';

/// Common decorations, box shadows, input decorations, and shared
/// property constants. Import this file everywhere instead of
/// re-declaring inline values.
class AppDecorations {
  AppDecorations._();

  // ─── Border Radii ──────────────────────────────────────────────
  static const double radiusXS = 8.0;
  static const double radiusSM = 12.0;
  static const double radiusMD = 16.0;
  static const double radiusLG = 20.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 99.0;

  static BorderRadius get borderRadiusXS => BorderRadius.circular(radiusXS);
  static BorderRadius get borderRadiusSM => BorderRadius.circular(radiusSM);
  static BorderRadius get borderRadiusMD => BorderRadius.circular(radiusMD);
  static BorderRadius get borderRadiusLG => BorderRadius.circular(radiusLG);
  static BorderRadius get borderRadiusXL => BorderRadius.circular(radiusXL);
  static BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);

  // ─── Box Shadows ───────────────────────────────────────────────

  /// Subtle card shadow for light theme
  static List<BoxShadow> get cardShadowLight => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  /// No shadow for dark theme cards
  static const List<BoxShadow> cardShadowDark = [];

  /// Returns the appropriate card shadow based on brightness
  static List<BoxShadow> cardShadow(bool isDark) =>
      isDark ? cardShadowDark : cardShadowLight;

  /// Elevated button shadow using primary color
  static List<BoxShadow> buttonShadow(Color primary) => [
        BoxShadow(
          color: primary.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Floating/modal bottom sheet shadow
  static List<BoxShadow> get bottomSheetShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, -4),
        ),
      ];

  /// Bottom navigation shadow
  static List<BoxShadow> get navShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, -4),
        ),
      ];

  /// Avatar/icon container shadow
  static List<BoxShadow> iconShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.35),
          blurRadius: 32,
          offset: const Offset(0, 12),
          spreadRadius: -4,
        ),
      ];

  // ─── Card Decoration ───────────────────────────────────────────

  static BoxDecoration cardDecoration({
    required bool isDark,
    Color? color,
    double radius = radiusLG,
  }) {
    final bg =
        color ?? (isDark ? const Color(0xFF1F2937) : const Color(0xFFFFFFFF));
    final border = isDark
        ? const Color(0xFF374151).withOpacity(0.3)
        : const Color(0xFFC3C6D7).withOpacity(0.3);
    return BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: border, width: 1),
      boxShadow: cardShadow(isDark),
    );
  }

  // ─── Input Decoration Factories ───────────────────────────────

  /// Standard outlined input decoration that adapts to theme
  static InputDecoration outlinedInput({
    required BuildContext context,
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? labelText,
    double borderRadius = radiusSM,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark ? const Color(0xFF1F2937) : Colors.white,
      hintStyle: TextStyle(
        fontSize: 14,
        color: cs.onSurfaceVariant.withOpacity(0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: cs.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: cs.error, width: 2),
      ),
    );
  }

  /// Filled (no border) input decoration
  static InputDecoration filledInput({
    required BuildContext context,
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? labelText,
    double borderRadius = radiusSM,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final fillColor =
        isDark ? const Color(0xFF1A2233) : const Color(0xFFF1F5F9);
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fillColor,
      hintStyle: TextStyle(
        fontSize: 14,
        color: cs.onSurfaceVariant.withOpacity(0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: cs.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: cs.error, width: 2),
      ),
    );
  }

  // ─── Section Container Decoration ─────────────────────────────

  static BoxDecoration sectionDecoration({
    required BuildContext context,
    double radius = radiusSM,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 16,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // ─── Icon Container Decoration ────────────────────────────────

  static BoxDecoration iconContainer({
    required Color color,
    double size = 12,
  }) =>
      BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size),
      );

  // ─── Chip Decoration ──────────────────────────────────────────

  static BoxDecoration chipDecoration({
    required Color bg,
    double radius = radiusFull,
  }) =>
      BoxDecoration(color: bg, borderRadius: BorderRadius.circular(radius));

  // ─── Avatar Decoration ────────────────────────────────────────

  static BoxDecoration avatarDecoration({
    required Color color,
    double radius = 14,
  }) =>
      BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      );

  // ─── Dashed/Outlined Add-Button Decoration ────────────────────

  static BoxDecoration addButtonDecoration({
    required BuildContext context,
    double radius = radiusLG,
  }) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      border: Border.all(color: cs.outlineVariant.withOpacity(0.5), width: 2),
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
