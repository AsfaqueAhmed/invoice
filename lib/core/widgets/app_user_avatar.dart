import 'package:flutter/material.dart';
import '../configs/theme/app_colors.dart';
import '../constants/app_decorations.dart';

/// A simple circular avatar that shows initials or a network image.
class AppUserAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;

  const AppUserAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 44,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: imageUrl != null
          ? ClipOval(
              child: Image.network(imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallback(colors)))
          : _fallback(colors),
    );
  }

  Widget _fallback(AppColorBase colors) {
    return Center(
      child: Text(
        _initials,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
          color: colors.primary,
        ),
      ),
    );
  }
}
