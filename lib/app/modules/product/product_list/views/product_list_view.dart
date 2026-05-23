import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bar.dart';
import 'package:flutter_getx_app/app/core/widgets/custom_cache_network_image.dart';
import 'package:flutter_getx_app/app/core/widgets/custom_text_field.dart';
import 'package:flutter_getx_app/app/modules/product/product_list/model/product_model.dart';
import 'package:flutter_getx_app/app/modules/product/product_list/views/widgets/app_status_chip.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Scaffold(
      appBar: const CustomAppAppbar(title: 'InvoiceFlow'),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: _DarkSearchBar(
                onChanged: (v) => controller.searchQuery.value = v,
              ),
            ),
            // Stats Row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Obx(() => Row(
                    children: [
                      Expanded(
                        child: _DarkStatCard(
                          label: 'TOTAL VALUE',
                          value: fmt.format(controller.totalInventoryValue),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DarkStatCard(
                          label: 'LOW STOCK ITEMS',
                          value: '${controller.lowStockCount}',
                          isAlert: true,
                        ),
                      ),
                    ],
                  )),
            ),
            Gaps.v16,
            // Product list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: controller.filteredProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (ctx, i) {
                    final product = controller.filteredProducts[i];
                    return _ProductCard(
                      product: product,
                      onTap: () => controller.selectProduct(product),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: _BottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_PRODUCT),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _DarkSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _DarkSearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            hintText: 'Search products...',
            onChanged: onChanged,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 12, right: 8),
              child: Icon(
                Icons.search_rounded,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey100),
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: Color(0xFF9CA3AF),
            size: 20,
          ),
        ),
      ],
    );
  }
}

class _DarkStatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isAlert;

  const _DarkStatCard({
    required this.label,
    required this.value,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          Gaps.v4,
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: !isAlert ? AppColors.textPrimary : AppColors.overdue,
                ),
              ),
              if (isAlert) ...[
                const SizedBox(width: 6),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.overdue,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  (Color, Color) get _stockColors {
    switch (product.stockStatus) {
      case StockStatus.inStock:
        return (AppColors.chipGreen, AppColors.chipGreenFg);
      case StockStatus.lowStock:
        return (AppColors.chipAmber, AppColors.chipAmberFg);
      case StockStatus.outOfStock:
        return (AppColors.chipRed, AppColors.chipRedFg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final colors = _stockColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Gaps.v4,
                      Text(
                        'SKU: ${product.sku}',
                        style: const TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                AppStatusChip(
                  label: product.stockStatus.label,
                  bg: colors.$1,
                  fg: colors.$2,
                ),
              ],
            ),
            Gaps.v4,
            Row(
              children: [
                Expanded(
                  child: _ProductMeta(
                      label: 'Stock Level', value: '${product.stockQty} units'),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _ProductMeta(
                    label: 'Unit Price',
                    value: fmt.format(product.price),
                    isPrice: true,
                  ),
                ),
                Gaps.h8,
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const CacheNetworkImage(
                    imageUrl: '',
                    height: 70,
                    width: 70,
                    borderRadius: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (product.stockStatus == StockStatus.lowStock)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: product.stockQty / 20,
                    backgroundColor: AppColors.grey100,
                    color: AppColors.overdue,
                    minHeight: 4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductMeta extends StatelessWidget {
  final String label;
  final String value;
  final bool isPrice;

  const _ProductMeta({
    required this.label,
    required this.value,
    this.isPrice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
          ),
        ),
        Gaps.v4,
        Text(
          value,
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isPrice ? AppColors.chipBlueFg : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
