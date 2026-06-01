import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/constants/padding.dart';
import 'package:flutter_getx_app/app/modules/product/product_list/controllers/product_list_controller.dart';
import 'package:get/get.dart';

class FilterProductWidget extends StatelessWidget {
  final ProductListController controller;

  const FilterProductWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outlineVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Gaps.v8,
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Filter Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: Get.back,
                  icon: Icon(Icons.close_rounded, color: colors.primary),
                ),
              ],
            ),
            Gaps.v8,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Price Range',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            Gaps.v8,
            Obx(() {
              return RangeSlider(
                activeColor: colors.primary,
                inactiveColor: colors.outlineVariant,
                min: 0,
                max: controller.maxPrice.value,
                divisions: _division(controller.maxPrice.value),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                values: controller.selectedPriceRange.value,
                onChanged: (values) {
                  controller.updatePriceRange(values);
                },
                labels: RangeLabels(
                  controller.selectedPriceRange.value.start.toStringAsFixed(0),
                  controller.selectedPriceRange.value.end.toStringAsFixed(0),
                ),
              );
            }),
            Gaps.v16,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Stock Level',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            Gaps.v8,
            Obx(() {
              return RangeSlider(
                activeColor: colors.primary,
                inactiveColor: colors.outlineVariant,
                min: 0,
                max: controller.maxStock.value.toDouble(),
                divisions: _division(controller.maxStock.value),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                values: controller.selectedStockRange.value,
                onChanged: (values) {
                  controller.updateStockRange(values);
                },
                labels: RangeLabels(
                  controller.selectedStockRange.value.start.toStringAsFixed(0),
                  controller.selectedStockRange.value.end.toStringAsFixed(0),
                ),
              );
            }),
            Gaps.v16,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Category',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            Gaps.v8,
            SizedBox(
              height: 40,
              child: Obx(() => ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...controller.categories.map((cat) {
                        final active = controller.selectedCategory.value == cat;
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
            Gaps.v8,
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
                      onChanged: (_) => controller.toggleProduct(),
                      activeTrackColor: colors.primary,
                    )),
              ],
            ),
            Gaps.v32,
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.filter_list_rounded, size: 20),
              label: Text(
                'Apply Filter',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colors.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Gaps.v12
          ],
        ),
      ),
    );
  }

  int _division(num end) {
    final val = (end / 10).toInt();
    if (val < 100) return 10;
    if (val < 1000) return 100;
    if (val < 10000) return 1000;
    return 10000;
  }
}
