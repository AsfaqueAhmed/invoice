import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_app/app/core/configs/text_style/app_text_styles.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:get/get.dart';

import '../configs/theme/app_color.dart';

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
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: isDark ? AppColor.darkSurface : AppColor.surface,
      elevation: 0,
      centerTitle: needTitleCentre,
      scrolledUnderElevation: 0,
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(1),
      //   child: Container(
      //     height: 1,
      //     color: isDark ? AppColors.grey700 : AppColors.grey100,
      //   ),
      // ),
      leading: needLeadingIcon
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8).copyWith(left: 16),
              child: IconButton(
                onPressed: backTap ?? Get.back,
                icon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    leadingIcon ?? Icons.arrow_back,
                    size: 20,
                    color: cs.primary,
                  ),
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: cs.primary),
        textAlign: TextAlign.left,
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
