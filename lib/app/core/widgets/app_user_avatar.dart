import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/widgets/custom_cache_network_image.dart';

class AppUserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;
  final double borderRadius;
  final Color color;

  const AppUserAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.size = 44,
    this.color = AppColors.primary,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: size * 0.35,
                  color: color,
                ),
              ),
            )
          : CacheNetworkImage(imageUrl: imageUrl ?? ''),
    );
  }
}
