import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
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
      body: Column(
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
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
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
          const SizedBox(height: 14),
          // Product list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary));
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                itemCount: controller.filteredProducts.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
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
      // bottomNavigationBar: _BottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_PRODUCT),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
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
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(
                  fontFamily: 'DMSans', fontSize: 14, color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 14,
                    color: Color(0xFF6B7280)),
                prefixIcon: Icon(Icons.search_rounded,
                    color: Color(0xFF6B7280), size: 20),
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: const Icon(Icons.tune_rounded,
              color: Color(0xFF9CA3AF), size: 20),
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
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      AppStatusChip(
                        label: product.stockStatus.label,
                        bg: colors.$1,
                        fg: colors.$2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SKU: ${product.sku}',
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _ProductMeta(
                          label: 'Stock Level',
                          value: '${product.stockQty} units'),
                      const SizedBox(width: 24),
                      _ProductMeta(
                          label: 'Unit Price',
                          value: fmt.format(product.price)),
                    ],
                  ),
                  if (product.stockStatus == StockStatus.lowStock)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: product.stockQty / 20,
                          backgroundColor:
                          AppColors.darkBorder,
                          color: AppColors.lowStock,
                          minHeight: 4,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Product Image placeholder
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.darkBorder,
                borderRadius: BorderRadius.circular(12),
              ),
              child: product.imageUrl != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(product.imageUrl!,
                    fit: BoxFit.cover),
              )
                  : const Icon(Icons.inventory_2_outlined,
                  color: Color(0xFF4B5563), size: 28),
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

  const _ProductMeta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 10,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
