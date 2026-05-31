import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../configs/text_style/app_text_styles.dart';
import '../configs/theme/app_colors.dart';

class CustomAppAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subTitle;
  final bool needLeadingIcon;
  final bool needTitleCentre;
  final bool isWhiteStatusBar;
  final bool needMoreActionIcon;
  final Function()? backTap;
  final Function()? moreTap;
  final bool needAddAction;
  final TextStyle? subtitleStyle;
  final Color? subtitleColor;
  final List<Widget>? action;
  final IconData? leadingIcon;

  const CustomAppAppbar({
    super.key,
    required this.title,
    this.needTitleCentre = false,
    this.isWhiteStatusBar = false,
    this.backTap,
    this.moreTap,
    this.needLeadingIcon = true,
    this.needMoreActionIcon = false,
    this.needAddAction = false,
    this.subTitle,
    this.subtitleStyle,
    this.subtitleColor,
    this.action,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppBar(
      backgroundColor: colors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: needTitleCentre,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: colors.outlineVariant.withOpacity(0.3),
        ),
      ),
      leading: needLeadingIcon
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8).copyWith(left: 16),
              child: IconButton(
                onPressed: backTap ?? Get.back,
                icon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    leadingIcon ?? Icons.arrow_back_rounded,
                    size: 20,
                    color: colors.primary,
                  ),
                ),
              ),
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(color: colors.primary),
            textAlign: TextAlign.left,
          ),
          if (subTitle != null)
            Text(
              subTitle!,
              style: AppTextStyles.bodySmall.copyWith(
                color: subtitleColor ?? colors.textSecondary,
              ),
            ),
        ],
      ),
      actions: action,
      systemOverlayStyle: isWhiteStatusBar
          ? const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            )
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
