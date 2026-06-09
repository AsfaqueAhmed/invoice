import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  }

  // ─── Actions ──────────────────────────────────────────────────

  Future<void> onStartBusiness() async {
    isPrimaryLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    isPrimaryLoading(false);
    Get.toNamed('/business-setup');
  }

  Future<void> onRestoreBackup() async {
    isSecondaryLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    isSecondaryLoading(false);
  }

  void onTermsTapped() {}

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
