import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_getx_app/app/core/utils/image_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/providers.dart';
import '../../domain/entities/product_entity.dart';
import 'product_list_provider.dart';

/// Form state for the "add/edit product" screen: the picked image, the
/// active toggle, the selected category and whether a save is in flight —
/// the text fields stay in `TextEditingController`s owned by the screen.
class AddProductState {
  const AddProductState({
    this.image,
    this.isActive = true,
    this.selectedCategory = '',
    this.isSaving = false,
  });

  final File? image;
  final bool isActive;
  final String selectedCategory;
  final bool isSaving;

  AddProductState copyWith({
    File? image,
    bool? isActive,
    String? selectedCategory,
    bool? isSaving,
  }) {
    return AddProductState(
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

final addProductProvider =
    NotifierProvider<AddProductNotifier, AddProductState>(
  AddProductNotifier.new,
);

class AddProductNotifier extends Notifier<AddProductState> {
  @override
  AddProductState build() => AddProductState(selectedCategory: productCategories[1]);

  /// Resets the form to reflect [product] when editing an existing one.
  void loadForEdit(ProductEntity product) {
    state = state.copyWith(
      selectedCategory: product.category,
      isActive: product.isProductActive,
      image: (product.image?.isNotEmpty ?? false) ? File(product.image!) : null,
    );
  }

  void selectCategory(String category) =>
      state = state.copyWith(selectedCategory: category);

  void toggleActive() => state = state.copyWith(isActive: !state.isActive);

  Future<void> pickImage() async {
    final picked = await ImageUtils.pickImageFromGallery();
    if (picked != null) state = state.copyWith(image: File(picked.path));
  }

  /// Persists the product. When [existing] is null a new product is created,
  /// otherwise the existing one is updated in place. Returns an error
  /// message on failure, or `null` on success.
  Future<String?> save({
    required ProductEntity? existing,
    required String name,
    required String sku,
    required String purchasePrice,
    required String sellingPrice,
    required String stock,
    required String description,
  }) async {
    state = state.copyWith(isSaving: true);
    try {
      String? savedImagePath;
      if (state.image != null) {
        savedImagePath = await ImageUtils.saveProductImage(state.image!);
      }

      final product = ProductEntity(
        id: existing?.id ?? const Uuid().v4(),
        name: name.trim(),
        sku: sku.trim().isEmpty
            ? 'SKU-${DateTime.now().millisecondsSinceEpoch}'
            : sku.trim(),
        category: state.selectedCategory,
        purchasePrice: double.tryParse(purchasePrice) ?? 0,
        sellingPrice: double.tryParse(sellingPrice) ?? 0,
        stock: int.tryParse(stock) ?? 0,
        description: description.trim(),
        image: savedImagePath ?? '',
        isProductActive: state.isActive,
      );

      final repository = ref.read(productRepositoryProvider);
      if (existing == null) {
        await repository.create(product);
      } else {
        await repository.update(product);
      }

      ref.invalidate(productListProvider);
      return null;
    } catch (e, stack) {
      debugPrint('Error saving product: $e\n$stack');
      return existing == null
          ? 'Could not save product.'
          : 'Could not update product.';
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}
