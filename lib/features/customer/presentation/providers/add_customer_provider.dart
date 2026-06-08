import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_getx_app/app/core/utils/image_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/providers.dart';
import '../../domain/entities/customer_entity.dart';
import 'customer_list_provider.dart';

/// Form state for the "add customer" screen: just the picked avatar and
/// whether a save is in flight — the text fields stay in `TextEditingController`s
/// owned by the screen, exactly like the rest of the app's forms.
class AddCustomerState {
  const AddCustomerState({this.avatar, this.isSaving = false});

  final File? avatar;
  final bool isSaving;

  AddCustomerState copyWith({File? avatar, bool? isSaving}) {
    return AddCustomerState(
      avatar: avatar ?? this.avatar,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

final addCustomerProvider =
    NotifierProvider<AddCustomerNotifier, AddCustomerState>(
  AddCustomerNotifier.new,
);

class AddCustomerNotifier extends Notifier<AddCustomerState> {
  @override
  AddCustomerState build() => const AddCustomerState();

  Future<void> pickAvatar() async {
    final picked = await ImageUtils.pickImageFromGallery();
    if (picked != null) state = state.copyWith(avatar: File(picked.path));
  }

  /// Builds the customer from the given form values and persists it.
  /// Returns an error message on failure, or `null` on success.
  Future<String?> save({
    required String fullName,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String stateName,
    required String postalCode,
  }) async {
    state = state.copyWith(isSaving: true);
    try {
      final fullAddress = [address, city, stateName, postalCode]
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .join(', ');

      final customer = CustomerEntity(
        id: const Uuid().v4(),
        name: fullName.trim(),
        phone: phone.trim(),
        email: email.trim(),
        address: fullAddress,
        totalDue: 0,
      );

      await ref.read(customerRepositoryProvider).create(customer);
      ref.invalidate(customerListProvider);
      return null;
    } catch (e, stack) {
      debugPrint('Error saving customer: $e\n$stack');
      return 'Could not save customer. Please try again.';
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}
