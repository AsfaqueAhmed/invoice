import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);

class OnboardingState {
  const OnboardingState({
    this.isPrimaryLoading = false,
    this.isSecondaryLoading = false,
  });

  final bool isPrimaryLoading;
  final bool isSecondaryLoading;

  OnboardingState copyWith({bool? isPrimaryLoading, bool? isSecondaryLoading}) {
    return OnboardingState(
      isPrimaryLoading: isPrimaryLoading ?? this.isPrimaryLoading,
      isSecondaryLoading: isSecondaryLoading ?? this.isSecondaryLoading,
    );
  }
}

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  Future<void> onStartBusiness() async {
    state = state.copyWith(isPrimaryLoading: true);
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(isPrimaryLoading: false);
    Get.toNamed(Routes.businessSetup);
  }

  Future<void> onRestoreBackup() async {
    state = state.copyWith(isSecondaryLoading: true);
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(isSecondaryLoading: false);
  }

  void onTermsTapped() {}
}
