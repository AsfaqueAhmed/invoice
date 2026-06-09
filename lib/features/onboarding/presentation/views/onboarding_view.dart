import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_getx_app/core/configs/text_style/app_text_styles.dart';
import 'package:flutter_getx_app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/core/constants/gaps.dart';
import 'package:flutter_getx_app/core/constants/padding.dart';
import 'package:flutter_getx_app/core/constants/app_decorations.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: Padding(
          padding: AppPadding.page,
          child: Column(
            children: [
              Expanded(
                child: _IllustrationSection(
                    controller: controller, colors: colors),
              ),
              AnimatedBuilder(
                animation: controller.animationController,
                builder: (context, _) => FadeTransition(
                  opacity: controller.fadeAnimation,
                  child: SlideTransition(
                    position: controller.slideAnimation,
                    child: _TypographySection(colors: colors),
                  ),
                ),
              ),
              Gaps.v24,
              AnimatedBuilder(
                animation: controller.animationController,
                builder: (context, _) => FadeTransition(
                  opacity: controller.fadeAnimation,
                  child: SlideTransition(
                    position: controller.slideAnimation,
                    child: _CtaSection(
                        controller: controller, colors: colors),
                  ),
                ),
              ),
              Gaps.v16,
            ],
          ),
        ),
      ),
    );
  }
}

class _IllustrationSection extends StatefulWidget {
  final OnboardingController controller;
  final AppColorBase colors;
  const _IllustrationSection(
      {required this.controller, required this.colors});

  @override
  State<_IllustrationSection> createState() =>
      _IllustrationSectionState();
}

class _IllustrationSectionState extends State<_IllustrationSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    _float = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(
          parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    return Center(
      child: AnimatedBuilder(
        animation: _float,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _float.value),
          child: child,
        ),
        child: SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryLight.withOpacity(0.15),
                ),
              ),
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.06),
                  borderRadius: AppDecorations.borderRadiusXL,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 30,
                      left: 20,
                      child: Transform.rotate(
                        angle: -0.15,
                        child: _MiniCard(
                          icon: Icons.receipt_long_rounded,
                          color: colors.primaryLight,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 28,
                      right: 18,
                      child: Transform.rotate(
                        angle: 0.12,
                        child: _MiniCard(
                          icon: Icons.attach_money_rounded,
                          color: colors.secondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow:
                            AppDecorations.iconShadow(colors.primary),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: colors.onPrimary,
                        size: 48,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _MiniCard({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Icon(icon, color: color, size: 26),
    );
  }
}

class _TypographySection extends StatelessWidget {
  final AppColorBase colors;
  const _TypographySection({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'InvoiceFlow',
          style: AppTextStyles.headlineLarge.copyWith(
            color: colors.textPrimary,
            letterSpacing: -0.3,
          ),
          textAlign: TextAlign.center,
        ),
        Gaps.v8,
        Text(
          'Simplified invoicing for your\ngrowing business ventures.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: colors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CtaSection extends StatelessWidget {
  final OnboardingController controller;
  final AppColorBase colors;
  const _CtaSection({required this.controller, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.isPrimaryLoading.value
                    ? null
                    : controller.onStartBusiness,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  disabledBackgroundColor:
                      colors.primary.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDecorations.borderRadiusSM,
                  ),
                  elevation: 4,
                  shadowColor: colors.primary.withOpacity(0.4),
                ),
                child: controller.isPrimaryLoading.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                              Icons.add_circle_outline_rounded,
                              size: 20),
                          Gaps.h8,
                          Text(
                            'Start Business',
                            style: AppTextStyles.titleMedium
                                .copyWith(color: colors.onPrimary),
                          ),
                        ],
                      ),
              ),
            )),
        Gaps.v12,
        Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: controller.isSecondaryLoading.value
                    ? null
                    : controller.onRestoreBackup,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primary,
                  side: BorderSide(
                      color: colors.outlineVariant, width: 1),
                  backgroundColor: colors.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDecorations.borderRadiusSM,
                  ),
                ),
                child: controller.isSecondaryLoading.value
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: colors.primary, strokeWidth: 2.5))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                              Icons.settings_backup_restore_rounded,
                              size: 20),
                          Gaps.h8,
                          Text(
                            'Restore Backup',
                            style: AppTextStyles.titleMedium
                                .copyWith(color: colors.primary),
                          ),
                        ],
                      ),
              ),
            )),
        Gaps.v16,
        GestureDetector(
          onTap: controller.onTermsTapped,
          child: Text(
            'By continuing, you agree to our Terms of Service',
            style: AppTextStyles.labelSmall.copyWith(
              color: colors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
