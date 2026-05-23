import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;
  final Color color;

  const AppAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.size = 44,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(size / 3),
        image: imageUrl != null
            ? DecorationImage(
          image: NetworkImage(imageUrl!),
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: imageUrl == null
          ? Center(
        child: Text(
          initials,
          style: TextStyle(
            fontFamily: 'DMSans',
            fontWeight: FontWeight.w700,
            fontSize: size * 0.35,
            color: color,
          ),
        ),
      )
          : null,
    );
  }
}