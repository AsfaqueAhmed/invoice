import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/constants/padding.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bottom_nav.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/core/widgets/app_text_field.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../domain/entities/product_entity.dart';
import '../providers/product_list_provider.dart';
import '../widgets/filter_product_sheet.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onAddProduct() {
    Get.toNamed(Routes.ADD_PRODUCT)?.then((value) {
      if (value == true) ref.read(productListProvider.notifier).refresh();
    });
  }

  void _onProductTap(ProductEntity product) {
    Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product);
  }

  void _onFilterTap() {
    final maxHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxHeight: maxHeight),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const FilterProductSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final productsAsync = ref.watch(productListProvider);
    final filtered = ref.watch(filteredProductsProvider);
    final totalValue = ref.watch(totalProductValueProvider);
    final lowStockCount = ref.watch(lowStockCountProvider);

    return Scaffold(
      backgroundColor: colors.scaffold,
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddProduct,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: RefreshIndicator(
        onRefresh: () => ref.read(productListProvider.notifier).refresh(),
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
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: AppPadding.all16,
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(
                        child: AppTextField(
                          hintText: 'Search products...',
                          controller: _searchController,
                          onChanged: (value) => ref
                              .read(productSearchQueryProvider.notifier)
                              .state = value,
                          prefixIcon:
                              Icon(Icons.search_rounded, color: colors.outline),
                        ),
                      ),
                      Gaps.h10,
                      GestureDetector(
                        onTap: _onFilterTap,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: AppDecorations.iconContainer(
                            color: colors.surfaceContainer,
                            size: 14,
                          ),
                          child: Icon(Icons.filter_list_rounded,
                              color: colors.primary),
                        ),
                      ),
                    ]),
                    Gaps.v16,
                    Row(children: [
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
                                totalValue,
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
                                  '$lowStockCount',
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
                    ]),
                    Gaps.v20,
                    productsAsync.when(
                      loading: () => Center(
                        child: Padding(
                          padding: AppPadding.v32,
                          child:
                              CircularProgressIndicator(color: colors.primary),
                        ),
                      ),
                      error: (error, _) => Center(
                        child: Padding(
                          padding: AppPadding.v32,
                          child: Text(
                            'Could not load products.',
                            style: TextStyle(color: colors.textSecondary),
                          ),
                        ),
                      ),
                      data: (_) {
                        if (filtered.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: AppPadding.v32,
                              child: Column(children: [
                                Icon(Icons.inventory_2_outlined,
                                    size: 48, color: colors.outline),
                                Gaps.v12,
                                Text(
                                  'No products found.',
                                  style:
                                      TextStyle(color: colors.textSecondary),
                                ),
                              ]),
                            ),
                          );
                        }
                        return Column(
                          children: filtered
                              .map((p) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _ProductCard(
                                      product: p,
                                      colors: colors,
                                      onTap: () => _onProductTap(p),
                                    ),
                                  ))
                              .toList(),
                        );
                      },
                    ),
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
                            ? colors.textPrimary.withValues(alpha: 0.5)
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
          Row(
            children: [
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
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                ],
              ),
              Gaps.h12,
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: AppDecorations.borderRadiusMD,
                  border: Border.all(
                      color: colors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: (product.image?.isNotEmpty ?? false)
                    ? ClipRRect(
                        borderRadius: AppDecorations.borderRadiusMD,
                        child: Image.file(
                          File(product.image ?? ""),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Icon(
                              Icons.inventory_2_rounded,
                              color: colors.outlineVariant,
                              size: 28,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_rounded,
                        color: colors.outlineVariant,
                        size: 28,
                      ),
              ),
            ],
          ),
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
