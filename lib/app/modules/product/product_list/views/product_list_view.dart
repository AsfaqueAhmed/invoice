import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/constants/app_decorations.dart';
import '../../../../core/constants/gaps.dart';
import '../../../../core/constants/padding.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../data/entities/product_entity.dart';
import '../controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onAddProduct,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              backgroundColor: colors.surface,
              elevation: 0,
              title: Text(
                'Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.add_rounded, color: colors.onSurfaceVariant),
                  onPressed: controller.onAddProduct,
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: AppPadding.all20,
                child: Column(
                  children: [
                    // ── Search + Filter ──────────────────────
                    Row(children: [
                      Expanded(
                        child: AppTextField(
                          hintText: 'Search products...',
                          controller: controller.searchController,
                          onChanged: controller.onSearch,
                          prefixIcon:
                              Icon(Icons.search_rounded, color: colors.outline),
                        ),
                      ),
                      Gaps.h10,
                      Container(
                        width: 52,
                        height: 52,
                        decoration: AppDecorations.iconContainer(
                          color: colors.surfaceContainer,
                          size: 14,
                        ),
                        child: Icon(Icons.filter_list_rounded,
                            color: colors.primary),
                      ),
                    ]),

                    Gaps.v16,

                    // ── Stats ────────────────────────────────
                    Obx(() => Row(children: [
                          Expanded(
                            child: AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TOTAL VALUE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: colors.textSecondary,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  Gaps.v4,
                                  Text(
                                    controller.totalValue,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: colors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Gaps.h12,
                          Expanded(
                            child: AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'LOW STOCK',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: colors.textSecondary,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  Gaps.v4,
                                  Row(children: [
                                    Text(
                                      '${controller.lowStockCount}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: colors.error,
                                      ),
                                    ),
                                    Gaps.h6,
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: colors.error,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        ])),

                    Gaps.v20,

                    // ── Product Cards ────────────────────────
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                          child: Padding(
                            padding: AppPadding.v32,
                            child: CircularProgressIndicator(
                                color: colors.primary),
                          ),
                        );
                      }
                      final list = controller.filtered;
                      if (list.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: AppPadding.v32,
                            child: Column(children: [
                              Icon(Icons.inventory_2_outlined,
                                  size: 48, color: colors.outline),
                              Gaps.v12,
                              Text(
                                'No products found.',
                                style: TextStyle(color: colors.textSecondary),
                              ),
                            ]),
                          ),
                        );
                      }
                      return Column(
                        children: list
                            .map((p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _ProductCard(
                                    product: p,
                                    colors: colors,
                                    onTap: () => controller.onProductTap(p),
                                  ),
                                ))
                            .toList(),
                      );
                    }),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductEntity product;
  final AppColorBase colors;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.colors,
    required this.onTap,
  });

  String get _status {
    if (product.stock == 0) return 'outofstock';
    if (product.stock <= 10) return 'lowstock';
    return 'instock';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: _status == 'outofstock'
                            ? colors.textPrimary.withOpacity(0.5)
                            : colors.textPrimary,
                      ),
                    ),
                    Text(
                      'SKU: ${product.sku}',
                      style: TextStyle(fontSize: 11, color: colors.outline),
                    ),
                  ]),
            ),
            _StockBadge(status: _status, colors: colors),
          ]),
          Gaps.v12,
          Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stock Level',
                      style:
                          TextStyle(fontSize: 11, color: colors.textSecondary),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${product.stock}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _status == 'outofstock'
                                ? colors.outline
                                : _status == 'lowstock'
                                    ? colors.error
                                    : colors.textPrimary,
                          ),
                        ),
                        Gaps.h4,
                        Text(
                          'units',
                          style: TextStyle(fontSize: 11, color: colors.outline),
                        ),
                      ],
                    ),
                  ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                'Unit Price',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              Text(
                '\$${product.sellingPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
            ]),
            Gaps.h12,
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: AppDecorations.borderRadiusMD,
                border:
                    Border.all(color: colors.outlineVariant.withOpacity(0.3)),
              ),
              child: Icon(Icons.inventory_2_rounded,
                  color: colors.outlineVariant, size: 28),
            ),
          ]),
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final String status;
  final AppColorBase colors;

  const _StockBadge({required this.status, required this.colors});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String label;

    switch (status) {
      case 'instock':
        bg = colors.chipGreenBg;
        fg = colors.chipGreenFg;
        label = 'In Stock';
        break;
      case 'lowstock':
        bg = colors.chipAmberBg;
        fg = colors.chipAmberFg;
        label = 'Low Stock';
        break;
      case 'outofstock':
        bg = colors.chipRedBg;
        fg = colors.chipRedFg;
        label = 'Out of Stock';
        break;
      default:
        bg = colors.chipGrayBg;
        fg = colors.chipGrayFg;
        label = 'Unknown';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: AppDecorations.chipDecoration(bg: bg),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
