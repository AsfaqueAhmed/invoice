import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bottom_nav.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/modules/product/product_list/controllers/product_list_controller.dart';
import 'package:get/get.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: controller.onAddProduct,
          child: const Icon(Icons.add_rounded, size: 28)),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: isDark ? AppColor.darkSurface : AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6)
                  .copyWith(bottom: 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Products',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: cs.primary),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_rounded, color: cs.onSurfaceVariant),
                    onPressed: controller.onAddProduct,
                  )
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      // Search + filter
                      Row(children: [
                        Expanded(
                          child: TextField(
                            controller: controller.searchController,
                            onChanged: controller.onSearch,
                            decoration: const InputDecoration(
                              hintText: 'Search products...',
                              prefixIcon: Icon(Icons.search_rounded),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                                color: cs.surfaceContainer,
                                borderRadius: BorderRadius.circular(14)),
                            child: Icon(Icons.filter_list_rounded,
                                color: cs.primary)),
                      ]),
                      const SizedBox(height: 16),
                      // Stats
                      Row(children: [
                        Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: cs.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: cs.outlineVariant
                                            .withOpacity(0.3))),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Total Value',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: cs.secondary,
                                              letterSpacing: 0.8)),
                                      const SizedBox(height: 4),
                                      Text(controller.totalValue,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: cs.onSurface)),
                                    ]))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: cs.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: cs.outlineVariant
                                            .withOpacity(0.3))),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Low Stock',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: cs.secondary,
                                              letterSpacing: 0.8)),
                                      const SizedBox(height: 4),
                                      Row(children: [
                                        Text('${controller.lowStockCount}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: cs.error)),
                                        const SizedBox(width: 6),
                                        Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                                color: cs.error,
                                                shape: BoxShape.circle)),
                                      ]),
                                    ]))),
                      ]),
                      const SizedBox(height: 20),
                      // Product cards
                      Obx(() => Column(
                          children: controller.filtered
                              .map((p) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: AppCard(
                                        onTap: () => controller.onProductTap(p),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                          Text(p['name'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 15,
                                                                  color: p['status'] ==
                                                                          'outofstock'
                                                                      ? cs.onSurface
                                                                          .withOpacity(
                                                                              0.5)
                                                                      : cs.onSurface)),
                                                          Text(
                                                              'SKU: ${p['sku']}',
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: cs
                                                                      .outline)),
                                                        ])),
                                                    _StockBadge(
                                                        status: p['status']),
                                                  ]),
                                              const SizedBox(height: 14),
                                              Row(children: [
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                      Text('Stock Level',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: cs
                                                                  .secondary)),
                                                      Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .baseline,
                                                          textBaseline:
                                                              TextBaseline
                                                                  .alphabetic,
                                                          children: [
                                                            Text(
                                                                '${p['stock']}',
                                                                style: TextStyle(
                                                                    fontSize: 22,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: p['status'] == 'outofstock'
                                                                        ? cs.outline
                                                                        : p['status'] == 'lowstock'
                                                                            ? cs.error
                                                                            : cs.onSurface)),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text('units',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: cs
                                                                        .outline)),
                                                          ]),
                                                    ])),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text('Unit Price',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: cs
                                                                  .secondary)),
                                                      Text(p['price'],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  cs.primary)),
                                                    ]),
                                                const SizedBox(width: 12),
                                                Container(
                                                    width: 72,
                                                    height: 72,
                                                    decoration: BoxDecoration(
                                                        color: cs
                                                            .surfaceContainerLow,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        border: Border.all(
                                                            color: cs
                                                                .outlineVariant
                                                                .withOpacity(
                                                                    0.3))),
                                                    child: Icon(
                                                        Icons
                                                            .inventory_2_rounded,
                                                        color:
                                                            cs.outlineVariant,
                                                        size: 28)),
                                              ]),
                                            ])),
                                  ))
                              .toList())),
                      const SizedBox(height: 80),
                    ]))),
          ],
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final String status;

  const _StockBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bg, fg, label) = switch (status) {
      'instock' => (
          const Color(0xFFE8F5E9),
          const Color(0xFF2E7D32),
          'In Stock'
        ),
      'lowstock' => (
          const Color(0xFFFFF8E1),
          const Color(0xFFF57F17),
          'Low Stock'
        ),
      'outofstock' => (
          const Color(0xFFFFEBEE),
          const Color(0xFFC62828),
          'Out of Stock'
        ),
      _ => (cs.surfaceContainerHigh, cs.onSurfaceVariant, 'Unknown'),
    };
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
        child: Text(label,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700, color: fg)));
  }
}
