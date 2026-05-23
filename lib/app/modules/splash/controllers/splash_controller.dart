import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ─── Animation Controllers ────────────────────────────────────
  late final AnimationController animationController;

  late final Animation<double> logoScale;
  late final Animation<double> logoOpacity;
  late final Animation<double> textOpacity;
  late final Animation<double> progressValue;
  late final Animation<double> subtitleOpacity;

  // ─── State ────────────────────────────────────────────────────
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Logo bounce entrance (0% → 50%)
    logoScale = TweenSequence<double>([
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
        parent: animationController,
        curve: const Interval(0.0, 0.5),
      ),
    );

    logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    subtitleOpacity = Tween<double>(begin: 0.0, end: 0.6).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  Future<void> _startSequence() async {
    // Run the entrance animation
    await animationController.forward();

    // Simulate async initialization (auth check, config load, etc.)
    await _initialize();

    // Navigate to onboarding (or home if already onboarded)
    // TODO: check onboarding completion flag from storage
    Get.offAllNamed(Routes.onboarding);
  }

  Future<void> _initialize() async {
    // TODO: Add real init logic here:
    // - Check stored auth token
    // - Load remote config
    // - Prefetch critical data
    await Future.delayed(const Duration(milliseconds: 600));
    isInitialized(true);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
