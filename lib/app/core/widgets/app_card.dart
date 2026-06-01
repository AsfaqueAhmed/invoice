import 'package:flutter/material.dart';
import '../configs/theme/app_colors.dart';
import '../constants/app_decorations.dart';

/// Universal card widget that automatically adapts to light/dark themes.
/// All cards in the app should use this widget.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final double radius;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.radius = AppDecorations.radiusLG,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = context.appColors;
    final bg = color ?? colors.cardBg;
    final border = colors.outlineVariant.withOpacity(0.3);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: border, width: 1),
            boxShadow: AppDecorations.cardShadow(isDark),
          ),
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

/// A stat/summary card used on dashboards & list headers.
/// Wraps [AppCard] with a standardized label + value + sub layout.
class AppStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color? valueColor;
  final Color? subColor;
  final IconData? subIcon;
  final double width;
  final double valueSize;
  final Color? cardColor;

  const AppStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.sub,
    this.valueColor,
    this.subColor,
    this.subIcon,
    this.width = 150,
    this.valueSize = 20,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppCard(
      color: cardColor,
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: cs.secondary,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: valueSize,
                fontWeight: FontWeight.w700,
                color: valueColor ?? cs.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            Row(
              children: [
                if (subIcon != null) ...[
                  Icon(subIcon,
                      size: 13,
                      color: subColor ?? cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    sub,
                    style: TextStyle(
                      fontSize: 11,
                      color: subColor ?? cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
