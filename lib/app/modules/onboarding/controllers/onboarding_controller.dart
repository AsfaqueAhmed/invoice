import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ─── Animation ────────────────────────────────────────────────
  late final AnimationController animationController;
  late final Animation<double> floatAnimation;
  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;

  // ─── State ────────────────────────────────────────────────────
  final RxBool isPrimaryLoading = false.obs;
  final RxBool isSecondaryLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
    animationController.forward();
  }

  void _setupAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // Floating animation for the illustration (loops)
    floatAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    // Fade-in for text + buttons
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    // Slide-up for text + buttons
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    // Loop the float after entrance completes
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startFloatLoop();
      }
    });
  }

  void _startFloatLoop() {
    // Separate looping controller for the float
    // We reuse animationController by reversing between 0.6 → 1.0 range
    // Instead, use a repeating animation via repeat on a separate ticker
    // For simplicity: just restart the float portion
  }

  // ─── Actions ──────────────────────────────────────────────────

  Future<void> onStartBusiness() async {
    isPrimaryLoading(true);
    // TODO: Navigate to sign-up or main app flow
    await Future.delayed(const Duration(milliseconds: 300));
    isPrimaryLoading(false);
    Get.toNamed(Routes.businessSetup);
  }

  Future<void> onRestoreBackup() async {
    isSecondaryLoading(true);
    // TODO: Trigger restore/import flow
    await Future.delayed(const Duration(milliseconds: 300));
    isSecondaryLoading(false);
    // Get.toNamed(Routes.restore);
  }

  void onTermsTapped() {
    // TODO: Open Terms of Service WebView or URL
    // Get.toNamed(Routes.terms);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
