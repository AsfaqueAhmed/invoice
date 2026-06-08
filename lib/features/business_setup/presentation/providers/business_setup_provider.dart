import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_getx_app/app/core/services/local_storage_service.dart';
import 'package:flutter_getx_app/app/core/utils/image_utils.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../data/providers.dart';
import '../../domain/entities/business_entity.dart';

const businessCurrencies = [
  {'value': 'USD', 'label': 'USD - US Dollar'},
  {'value': 'EUR', 'label': 'EUR - Euro'},
  {'value': 'GBP', 'label': 'GBP - British Pound'},
  {'value': 'CAD', 'label': 'CAD - Canadian Dollar'},
  {'value': 'AUD', 'label': 'AUD - Australian Dollar'},
  {'value': 'BDT', 'label': 'BDT - Bangladeshi Taka'},
];

/// Form state for the "set up / edit business" screen: the picked logo,
/// selected currency and the loading/success animation flags — the text
/// fields stay in `TextEditingController`s owned by the screen.
class BusinessSetupState {
  const BusinessSetupState({
    this.logo,
    this.currency = 'BDT',
    this.isLoading = false,
    this.isSuccess = false,
  });

  final File? logo;
  final String currency;
  final bool isLoading;
  final bool isSuccess;

  BusinessSetupState copyWith({
    File? logo,
    String? currency,
    bool? isLoading,
    bool? isSuccess,
  }) {
    return BusinessSetupState(
      logo: logo ?? this.logo,
      currency: currency ?? this.currency,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

final businessSetupProvider =
    NotifierProvider<BusinessSetupNotifier, BusinessSetupState>(
  BusinessSetupNotifier.new,
);

class BusinessSetupNotifier extends Notifier<BusinessSetupState> {
  @override
  BusinessSetupState build() => const BusinessSetupState();

  /// Resets the form to reflect [business] when editing an existing one.
  void loadForEdit(BusinessEntity business) {
    state = state.copyWith(
      currency: business.currency,
      logo: business.logo.isNotEmpty ? File(business.logo) : null,
    );
  }

  void selectCurrency(String currency) =>
      state = state.copyWith(currency: currency);

  Future<void> pickLogo() async {
    final picked = await ImageUtils.pickImageFromGallery();
    if (picked != null) state = state.copyWith(logo: File(picked.path));
  }

  /// Persists the business profile, plays the success animation, then
  /// navigates: a brand-new profile marks onboarding complete and lands on
  /// the dashboard, an edit just pops back to settings. Returns an error
  /// message on failure, or `null` on success.
  Future<String?> submit({
    required BusinessEntity? existing,
    required String name,
    required String phone,
    required String address,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      String? savedLogoPath;
      if (state.logo != null) {
        savedLogoPath = await ImageUtils.saveBusinessImage(state.logo!);
      }

      final business = BusinessEntity(
        id: existing?.id ?? const Uuid().v4(),
        name: name.trim(),
        phone: phone.trim(),
        address: address.trim(),
        currency: state.currency,
        logo: savedLogoPath ?? '',
      );

      final repository = ref.read(businessRepositoryProvider);
      if (existing == null) {
        await repository.create(business);
      } else {
        await repository.update(business);
      }

      await Future.delayed(const Duration(milliseconds: 1500));
      state = state.copyWith(isSuccess: true);
      await Future.delayed(const Duration(milliseconds: 600));

      ref.invalidate(businessListProvider);

      if (existing == null) {
        await LocalStorageService.setOnCreatedFirstBusiness();
        Get.offAllNamed(Routes.dashboard);
      } else {
        Get.back(result: true);
      }
      return null;
    } catch (e, stack) {
      debugPrint('Error saving business profile: $e\n$stack');
      return 'Could not save business profile.';
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

/// Loads every saved business profile (in practice there's just one — the
/// settings screen reads `.first` for the active profile card).
final businessListProvider =
    AsyncNotifierProvider<BusinessListNotifier, List<BusinessEntity>>(
  BusinessListNotifier.new,
);

class BusinessListNotifier extends AsyncNotifier<List<BusinessEntity>> {
  @override
  Future<List<BusinessEntity>> build() {
    return ref.watch(businessRepositoryProvider).getAll();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(businessRepositoryProvider).getAll(),
    );
  }
}
