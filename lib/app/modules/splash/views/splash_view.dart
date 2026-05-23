import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/text_style/app_text_styles.dart';
import '../../../core/constants/gaps.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldLight,
      body: Stack(
        children: [
          // ── Ambient Background Blobs ───────────────────────────
          _AmbientBackground(),

          // ── Central Content ───────────────────────────────────
          Center(
            child: AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Logo ──────────────────────────────────────
                    Opacity(
                      opacity: controller.logoOpacity.value,
                      child: Transform.scale(
                        scale: controller.logoScale.value,
                        child: const _LogoContainer(),
                      ),
                    ),

                    Gaps.v24,

                    // ── Brand Name ───────────────────────────────
                    Opacity(
                      opacity: controller.textOpacity.value,
                      child: Text(
                        'InvoiceFlow',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          fontSize: 32,
                        ),
                      ),
                    ),

                    Gaps.v8,

                    // ── Tagline ───────────────────────────────────
                    Opacity(
                      opacity: controller.subtitleOpacity.value,
                      child: Text(
                        'FINANCIAL MASTERY SIMPLIFIED',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey500,
                          letterSpacing: 2.0,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ── Bottom Progress Indicator ──────────────────────────
          Positioned(
            bottom: 96,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, _) {
                return Opacity(
                  opacity: (controller.progressValue.value * 2).clamp(0.0, 1.0),
                  child: Column(
                    children: [
                      // Progress bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 180),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: controller.progressValue.value,
                            minHeight: 2,
                            backgroundColor: AppColors.grey200,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      Gaps.v12,

                      // Status text
                      Text(
                        'Initializing secure session...',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ── Decorative Floating Dots ───────────────────────────
          const _FloatingDots(),
        ],
      ),
    );
  }
}

// ─── Logo Container Widget ───────────────────────────────────────

class _LogoContainer extends StatelessWidget {
  const _LogoContainer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.12),
          ),
        ),

        // Main icon box
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: 32,
                offset: const Offset(0, 12),
                spreadRadius: -4,
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 52,
          ),
        ),
      ],
    );
  }
}

// ─── Ambient Background ──────────────────────────────────────────

class _AmbientBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-left blob
        Positioned(
          top: -60,
          left: -60,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.05),
            ),
          ),
        ),
        // Bottom-right blob
        Positioned(
          bottom: -40,
          right: -40,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withOpacity(0.07),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Floating Dot Decorations ────────────────────────────────────

class _FloatingDots extends StatelessWidget {
  const _FloatingDots();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.25,
          left: 40,
          child: _Dot(size: 8, color: AppColors.primary.withOpacity(0.2)),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.33,
          right: 48,
          child: _Dot(size: 12, color: AppColors.secondary.withOpacity(0.15)),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          right: 80,
          child: _Dot(size: 6, color: AppColors.primary.withOpacity(0.1)),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final double size;
  final Color color;

  const _Dot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
