import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/text_style/app_text_styles.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/services/local_storage_service.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

/// Animated splash screen. The `AnimationController` needs a `vsync`, so it's
/// owned by the screen's state directly rather than a Riverpod provider —
/// once the entrance sequence finishes, it routes to onboarding or the
/// dashboard depending on whether a business profile already exists.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<double> _progressValue;
  late final Animation<double> _subtitleOpacity;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Logo bounce entrance (0% → 50%)
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.85, end: 1.06)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.06, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 0.6).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  Future<void> _startSequence() async {
    await _animationController.forward();
    await _initialize();

    if (!mounted) return;
    if (LocalStorageService.hasCreatedFirstBusiness) {
      Get.offAllNamed(Routes.dashboard);
    } else {
      Get.offAllNamed(Routes.onboarding);
    }
  }

  Future<void> _initialize() async {
    // TODO: Add real init logic here:
    // - Check stored auth token
    // - Load remote config
    // - Prefetch critical data
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
              animation: _animationController,
              builder: (context, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: _LogoContainer(colors: colors),
                      ),
                    ),
                    Gaps.v24,
                    Opacity(
                      opacity: _textOpacity.value,
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
                      opacity: _subtitleOpacity.value,
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
              animation: _animationController,
              builder: (context, _) {
                return Opacity(
                  opacity: (_progressValue.value * 2).clamp(0.0, 1.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 180),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: _progressValue.value,
                            minHeight: 2,
                            backgroundColor:
                                colors.outlineVariant.withValues(alpha: 0.3),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(colors.primary),
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
            color: colors.primary.withValues(alpha: 0.12),
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
                color: colors.primary.withValues(alpha: 0.35),
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
              color: colors.primary.withValues(alpha: 0.05),
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
              color: colors.secondary.withValues(alpha: 0.07),
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
          child: _Dot(size: 8, color: colors.primary.withValues(alpha: 0.2)),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.33,
          right: 48,
          child:
              _Dot(size: 12, color: colors.secondary.withValues(alpha: 0.15)),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          right: 80,
          child: _Dot(size: 6, color: colors.primary.withValues(alpha: 0.1)),
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
