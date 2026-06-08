import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/product_list_provider.dart';

/// Bottom sheet for narrowing the product list by price, stock, category
/// and active state. Reads/writes [productFiltersProvider] directly so
/// changes are reflected live in [filteredProductsProvider].
class FilterProductSheet extends ConsumerWidget {
  const FilterProductSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final filters = ref.watch(productFiltersProvider);
    final maxPrice = ref.watch(productMaxPriceProvider);
    final maxStock = ref.watch(productMaxStockProvider);
    final priceRange = filters.priceRange ?? RangeValues(0, maxPrice);
    final stockRange = filters.stockRange ?? RangeValues(0, maxStock.toDouble());

    void updateFilters(ProductFilters Function(ProductFilters) update) {
      ref.read(productFiltersProvider.notifier).update(update);
    }

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
            RangeSlider(
              activeColor: colors.primary,
              inactiveColor: colors.outlineVariant,
              min: 0,
              max: maxPrice,
              divisions: _division(maxPrice),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              values: priceRange,
              onChanged: (values) =>
                  updateFilters((f) => f.copyWith(priceRange: values)),
              labels: RangeLabels(
                priceRange.start.toStringAsFixed(0),
                priceRange.end.toStringAsFixed(0),
              ),
            ),
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
            RangeSlider(
              activeColor: colors.primary,
              inactiveColor: colors.outlineVariant,
              min: 0,
              max: maxStock.toDouble(),
              divisions: _division(maxStock),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              values: stockRange,
              onChanged: (values) =>
                  updateFilters((f) => f.copyWith(stockRange: values)),
              labels: RangeLabels(
                stockRange.start.toStringAsFixed(0),
                stockRange.end.toStringAsFixed(0),
              ),
            ),
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...productCategories.map((cat) {
                    final active = filters.category == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () =>
                            updateFilters((f) => f.copyWith(category: cat)),
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
                Switch.adaptive(
                  value: filters.activeOnly,
                  onChanged: (value) =>
                      updateFilters((f) => f.copyWith(activeOnly: value)),
                  activeTrackColor: colors.primary,
                ),
              ],
            ),
            Gaps.v32,
            ElevatedButton.icon(
              onPressed: Get.back,
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
            Gaps.v12,
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
