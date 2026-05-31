import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/constants/app_decorations.dart';
import '../../../../core/constants/gaps.dart';
import '../../../../core/constants/padding.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
          onPressed: Get.back,
        ),
        title: Text(
          'Add Product',
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        decoration: BoxDecoration(
          color: colors.cardBg,
          boxShadow: AppDecorations.bottomSheetShadow,
        ),
        child: Obx(() => ElevatedButton.icon(
              onPressed: controller.isSaving.value ? null : controller.onSave,
              icon: controller.isSaving.value
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: colors.onPrimary))
                  : const Icon(Icons.save_rounded, size: 20),
              label: Text(
                controller.isSaving.value ? 'Saving...' : 'Save Product',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDecorations.borderRadiusMD,
                ),
              ),
            )),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: AppPadding.all20,
          child: Column(
            children: [
              // Image upload placeholder
              GestureDetector(
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
                  child: Column(
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

              Gaps.v16,

              // SKU + Barcode
              Row(children: [
                Expanded(
                  child: AppFieldLabel(
                    label: 'SKU',
                    child: AppTextField(
                      hintText: 'CF-1002',
                      controller: controller.skuController,
                    ),
                  ),
                ),
                Gaps.h12,
                Expanded(
                  child: AppFieldLabel(
                    label: 'Barcode',
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.barcode_reader,
                          color: colors.primary, size: 18),
                      label: Text(
                        'Scan',
                        style: TextStyle(color: colors.primary),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppDecorations.borderRadiusSM,
                        ),
                        side: BorderSide(color: colors.outlineVariant),
                      ),
                    ),
                  ),
                ),
              ]),

              Gaps.v16,

              // Purchase Price + Selling Price
              Row(children: [
                Expanded(
                  child: AppFieldLabel(
                    label: 'Purchase Price (\$)',
                    child: AppTextField(
                      hintText: '0.00',
                      controller: controller.purchasePriceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
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
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                      ],
                      prefixIcon: Icon(Icons.payments_outlined,
                          color: colors.outline, size: 20),
                    ),
                  ),
                ),
              ]),

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
                        ...controller.categories.map((cat) {
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
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colors.surfaceContainerLow,
                              shape: BoxShape.circle,
                              border: Border.all(color: colors.outlineVariant),
                            ),
                            child: Icon(Icons.add_rounded,
                                color: colors.primary, size: 20),
                          ),
                        ),
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration:
                        AppDecorations.chipDecoration(bg: colors.chipGreenBg),
                    child: Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colors.chipGreenFg,
                      ),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
