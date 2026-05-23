import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/text_style/app_text_styles.dart';
import '../../../core/constants/gaps.dart';
import '../../../core/constants/padding.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.scaffoldLight, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppPadding.page,
            child: Column(
              children: [
                // ── Illustration ──────────────────────────────────
                Expanded(
                  child: _IllustrationSection(controller: controller),
                ),

                // ── Typography ────────────────────────────────────
                AnimatedBuilder(
                  animation: controller.animationController,
                  builder: (context, _) {
                    return FadeTransition(
                      opacity: controller.fadeAnimation,
                      child: SlideTransition(
                        position: controller.slideAnimation,
                        child: _TypographySection(),
                      ),
                    );
                  },
                ),

                Gaps.v24,

                // ── CTA Buttons ───────────────────────────────────
                AnimatedBuilder(
                  animation: controller.animationController,
                  builder: (context, _) {
                    return FadeTransition(
                      opacity: controller.fadeAnimation,
                      child: SlideTransition(
                        position: controller.slideAnimation,
                        child: _CtaSection(controller: controller),
                      ),
                    );
                  },
                ),

                Gaps.v16,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Illustration Section ────────────────────────────────────────

class _IllustrationSection extends StatefulWidget {
  final OnboardingController controller;
  const _IllustrationSection({required this.controller});

  @override
  State<_IllustrationSection> createState() => _IllustrationSectionState();
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
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _float,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _float.value),
            child: child,
          );
        },
        child: SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Decorative glow blob
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLight.withOpacity(0.15),
                ),
              ),

              // Illustration placeholder (replace with your asset or network image)
              _IllustrationPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }
}

class _IllustrationPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative invoice cards in background
          Positioned(
            top: 30,
            left: 20,
            child: _MiniCard(
              icon: Icons.receipt_long_rounded,
              color: AppColors.primaryLight,
              rotation: -0.15,
            ),
          ),
          Positioned(
            bottom: 28,
            right: 18,
            child: _MiniCard(
              icon: Icons.attach_money_rounded,
              color: AppColors.secondary,
              rotation: 0.12,
            ),
          ),
          // Center icon
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      ),
    );
    // ── To use a real image instead, replace with: ──────────────
    // return Image.asset('assets/images/onboarding.png', fit: BoxFit.contain);
    // or:
    // return Image.network('YOUR_IMAGE_URL', fit: BoxFit.contain);
  }
}

class _MiniCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double rotation;

  const _MiniCard({
    required this.icon,
    required this.color,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}

// ─── Typography Section ──────────────────────────────────────────

class _TypographySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'InvoiceFlow',
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.grey900,
            letterSpacing: -0.3,
          ),
          textAlign: TextAlign.center,
        ),
        Gaps.v8,
        Text(
          'Simplified invoicing for your\ngrowing business ventures.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.grey500,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── CTA Section ─────────────────────────────────────────────────

class _CtaSection extends StatelessWidget {
  final OnboardingController controller;
  const _CtaSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary button
        Obx(
          () => _PrimaryButton(
            label: 'Start Business',
            icon: Icons.add_circle_outline_rounded,
            isLoading: controller.isPrimaryLoading.value,
            onTap: controller.onStartBusiness,
          ),
        ),

        Gaps.v12,

        // Secondary button
        Obx(
          () => _SecondaryButton(
            label: 'Restore Backup',
            icon: Icons.settings_backup_restore_rounded,
            isLoading: controller.isSecondaryLoading.value,
            onTap: controller.onRestoreBackup,
          ),
        ),

        Gaps.v16,

        // Terms
        GestureDetector(
          onTap: controller.onTermsTapped,
          child: Text(
            'By continuing, you agree to our Terms of Service',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.grey400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.4),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  Gaps.h8,
                  Text(
                    label,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.grey300, width: 1),
          backgroundColor: AppColors.grey50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  Gaps.h8,
                  Text(
                    label,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
