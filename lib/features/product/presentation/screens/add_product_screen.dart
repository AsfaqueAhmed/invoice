import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/constants/padding.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/core/widgets/app_text_field.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../domain/entities/product_entity.dart';
import '../providers/add_product_provider.dart';
import '../providers/product_list_provider.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _purchasePriceCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  ProductEntity? get _product => Get.arguments as ProductEntity?;

  @override
  void initState() {
    super.initState();
    final product = _product;
    if (product != null) {
      _nameCtrl.text = product.name;
      _skuCtrl.text = product.sku;
      _purchasePriceCtrl.text = product.purchasePrice.toString();
      _priceCtrl.text = product.sellingPrice.toString();
      _stockCtrl.text = product.stock.toString();
      _descCtrl.text = product.description ?? '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(addProductProvider.notifier).loadForEdit(product);
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _purchasePriceCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  String? _validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final product = _product;
    final error = await ref.read(addProductProvider.notifier).save(
          existing: product,
          name: _nameCtrl.text,
          sku: _skuCtrl.text,
          purchasePrice: _purchasePriceCtrl.text,
          sellingPrice: _priceCtrl.text,
          stock: _stockCtrl.text,
          description: _descCtrl.text,
        );

    if (error != null) {
      Get.snackbar('Error', error, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (product == null) {
      Get.back(result: true);
    } else {
      Get.until((route) => route.settings.name == Routes.PRODUCT_LIST);
    }
    Get.snackbar(
      'Success',
      product == null ? 'Product saved!' : 'Product Updated!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = _product;
    final state = ref.watch(addProductProvider);

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
          onPressed: Get.back,
        ),
        title: Text(
          product == null ? 'Add Product' : 'Update Product',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colors.primary,
          ),
        ),
        actions: [
          Container(
            width: 36,
            height: 36,
            margin: AppMargin.right12,
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: colors.primary, size: 18),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: colors.cardBg,
            boxShadow: AppDecorations.bottomSheetShadow,
          ),
          child: ElevatedButton.icon(
            onPressed: state.isSaving ? null : _onSubmit,
            icon: state.isSaving
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: colors.onPrimary))
                : const Icon(Icons.save_rounded, size: 20),
            label: Text(
              state.isSaving
                  ? 'Saving...'
                  : product != null
                      ? 'Update Product'
                      : 'Save Product',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: AppDecorations.borderRadiusMD,
              ),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: AppPadding.all16,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => ref.read(addProductProvider.notifier).pickImage(),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    border: Border.all(
                        color: colors.outlineVariant,
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: AppDecorations.borderRadiusXL,
                  ),
                  child: state.image != null
                      ? ClipRRect(
                          borderRadius: AppDecorations.borderRadiusXL,
                          child: Image.file(state.image!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined,
                                color: colors.outline, size: 32),
                            Gaps.v6,
                            Text(
                              'Add Image',
                              style: TextStyle(
                                fontSize: 11,
                                color: colors.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              Gaps.v24,

              AppFieldLabel(
                label: 'Product Name',
                child: AppTextField(
                  hintText: 'e.g. Premium Coffee Beans',
                  controller: _nameCtrl,
                  validator: _validateRequired,
                  prefixIcon: Icon(Icons.inventory_2_outlined,
                      color: colors.outline, size: 20),
                ),
              ),

              Gaps.v12,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Active Product',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  Switch.adaptive(
                    value: state.isActive,
                    onChanged: (_) =>
                        ref.read(addProductProvider.notifier).toggleActive(),
                    activeTrackColor: colors.primary,
                  ),
                ],
              ),
              Gaps.v12,

              AppFieldLabel(
                label: 'SKU',
                child: AppTextField(
                  hintText: 'CF-1002',
                  controller: _skuCtrl,
                ),
              ),

              Gaps.v16,

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppFieldLabel(
                      label: 'Purchase Price (\$)',
                      child: AppTextField(
                        hintText: '0.00',
                        controller: _purchasePriceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                        ],
                        prefixIcon: Icon(Icons.shopping_cart_outlined,
                            color: colors.outline, size: 20),
                      ),
                    ),
                  ),
                  Gaps.h12,
                  Expanded(
                    child: AppFieldLabel(
                      label: 'Selling Price (\$)',
                      child: AppTextField(
                        hintText: '0.00',
                        controller: _priceCtrl,
                        validator: _validateRequired,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                        ],
                        prefixIcon: Icon(Icons.payments_outlined,
                            color: colors.outline, size: 20),
                      ),
                    ),
                  ),
                ],
              ),

              Gaps.v16,

              AppFieldLabel(
                label: 'Stock Qty',
                child: AppTextField(
                  hintText: '0',
                  controller: _stockCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  prefixIcon: Icon(Icons.inbox_outlined,
                      color: colors.outline, size: 20),
                ),
              ),

              Gaps.v16,

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurfaceVariant,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Gaps.v8,
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...productCategories.skip(1).map((cat) {
                      final active = state.selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => ref
                              .read(addProductProvider.notifier)
                              .selectCategory(cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: AppDecorations.chipDecoration(
                              bg: active
                                  ? colors.primaryContainer
                                  : colors.surfaceContainerHigh,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? colors.onPrimaryContainer
                                    : colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              Gaps.v16,

              AppFieldLabel(
                label: 'Description (Optional)',
                child: AppTextField(
                  hintText: 'Add some notes about the product...',
                  controller: _descCtrl,
                  maxLines: 3,
                  minLines: 3,
                ),
              ),

              Gaps.v16,

              AppCard(
                child: Row(children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: AppDecorations.avatarDecoration(
                        color: colors.secondaryContainer),
                    child: Icon(Icons.inventory_2_rounded,
                        color: colors.onSurfaceVariant),
                  ),
                  Gaps.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inventory Preview',
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _nameCtrl.text.trim().isEmpty
                              ? 'Product Name'
                              : _nameCtrl.text,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: AppDecorations.chipDecoration(
                        bg: state.isActive
                            ? colors.chipGreenBg
                            : colors.chipRedBg),
                    child: Text(
                      state.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: state.isActive
                            ? colors.chipGreenFg
                            : colors.chipRedFg,
                      ),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
