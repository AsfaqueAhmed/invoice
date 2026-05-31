import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/configs/text_style/app_text_styles.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/gaps.dart';
import '../controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      body: Stack(
        children: [
          // Ambient blobs
          _AmbientBackground(colors: colors),

          // Central content
          Center(
            child: AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Opacity(
                      opacity: controller.logoOpacity.value,
                      child: Transform.scale(
                        scale: controller.logoScale.value,
                        child: _LogoContainer(colors: colors),
                      ),
                    ),
                    Gaps.v24,
                    Opacity(
                      opacity: controller.textOpacity.value,
                      child: Text(
                        'InvoiceFlow',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    Gaps.v8,
                    Opacity(
                      opacity: controller.subtitleOpacity.value,
                      child: Text(
                        'FINANCIAL MASTERY SIMPLIFIED',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colors.textTertiary,
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

          // Bottom progress
          Positioned(
            bottom: 96,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, _) {
                return Opacity(
                  opacity:
                      (controller.progressValue.value * 2).clamp(0.0, 1.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 180),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: controller.progressValue.value,
                            minHeight: 2,
                            backgroundColor:
                                colors.outlineVariant.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                colors.primary),
                          ),
                        ),
                      ),
                      Gaps.v12,
                      Text(
                        'Initializing secure session...',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colors.textTertiary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Floating dots
          _FloatingDots(colors: colors),
        ],
      ),
    );
  }
}

class _LogoContainer extends StatelessWidget {
  final AppColorBase colors;
  const _LogoContainer({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.primary.withOpacity(0.12),
          ),
        ),
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withOpacity(0.35),
                blurRadius: 32,
                offset: const Offset(0, 12),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            color: colors.onPrimary,
            size: 52,
          ),
        ),
      ],
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  final AppColorBase colors;
  const _AmbientBackground({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -60,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary.withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          right: -40,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.secondary.withOpacity(0.07),
            ),
          ),
        ),
      ],
    );
  }
}

class _FloatingDots extends StatelessWidget {
  final AppColorBase colors;
  const _FloatingDots({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.25,
          left: 40,
          child: _Dot(
              size: 8, color: colors.primary.withOpacity(0.2)),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.33,
          right: 48,
          child: _Dot(
              size: 12, color: colors.secondary.withOpacity(0.15)),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          right: 80,
          child: _Dot(
              size: 6, color: colors.primary.withOpacity(0.1)),
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
