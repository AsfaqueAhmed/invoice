import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter_getx_app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/core/constants/gaps.dart';
import 'package:flutter_getx_app/core/constants/padding.dart';
import 'package:flutter_getx_app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/core/widgets/app_text_field.dart';
import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
          onPressed: Get.back,
        ),
        title: Text(
          controller.editingProduct == null ? 'Add Product' : 'Update Product',
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
          child: Obx(() => ElevatedButton.icon(
                onPressed: controller.isSaving.value
                    ? null
                    : controller.editingProduct == null
                        ? controller.onSave
                        : controller.onUpdate,
                icon: controller.isSaving.value
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: colors.onPrimary))
                    : const Icon(Icons.save_rounded, size: 20),
                label: Text(
                  controller.isSaving.value
                      ? 'Saving...'
                      : controller.editingProduct != null
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
              )),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: AppPadding.all16,
          child: Column(
            children: [
              // Image upload placeholder
              GestureDetector(
                onTap: controller.onPickImage,
                child: Obx(() {
                  final file = controller.productImage.value;
                  return Container(
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
                    child: file != null
                        ? ClipRRect(
                            borderRadius: AppDecorations.borderRadiusXL,
                            child: Image.file(file, fit: BoxFit.cover),
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
                  );
                }),
              ),

              Gaps.v24,

              // Product name
              AppFieldLabel(
                label: 'Product Name',
                child: AppTextField(
                  hintText: 'e.g. Premium Coffee Beans',
                  controller: controller.nameController,
                  validator: controller.validateRequired,
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
                  Obx(() => Switch.adaptive(
                        value: controller.isActive.value,
                        onChanged: (_) => controller.toggleActive(),
                        activeTrackColor: colors.primary,
                      )),
                ],
              ),
              Gaps.v12,

              // SKU
              Row(
                children: [
                  Expanded(
                    child: AppFieldLabel(
                      label: 'SKU',
                      child: AppTextField(
                        hintText: 'CF-1002',
                        controller: controller.skuController,
                      ),
                    ),
                  ),
                ],
              ),

              Gaps.v16,

              // Purchase Price + Selling Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppFieldLabel(
                      label: 'Purchase Price (\$)',
                      child: AppTextField(
                        hintText: '0.00',
                        controller: controller.purchasePriceController,
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
                        controller: controller.priceController,
                        validator: controller.validateRequired,
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

              // Stock
              AppFieldLabel(
                label: 'Stock Qty',
                child: AppTextField(
                  hintText: '0',
                  controller: controller.stockController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  prefixIcon: Icon(Icons.inbox_outlined,
                      color: colors.outline, size: 20),
                ),
              ),

              Gaps.v16,

              // Category chips
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
                child: Obx(() => ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...AddProductController.categories.map((cat) {
                          final active =
                              controller.selectedCategory.value == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => controller.onCategorySelect(cat),
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
                    )),
              ),

              Gaps.v16,

              // Description
              AppFieldLabel(
                label: 'Description (Optional)',
                child: AppTextField(
                  hintText: 'Add some notes about the product...',
                  controller: controller.descController,
                  maxLines: 3,
                  minLines: 3,
                ),
              ),

              Gaps.v16,

              // Preview card
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
                          controller.nameController.text.trim().isEmpty
                              ? 'Product Name'
                              : controller.nameController.text,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: AppDecorations.chipDecoration(
                          bg: controller.isActive.value
                              ? colors.chipGreenBg
                              : colors.chipRedBg),
                      child: Text(
                        controller.isActive.value ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: controller.isActive.value
                              ? colors.chipGreenFg
                              : colors.chipRedFg,
                        ),
                      ),
                    );
                  }),
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
