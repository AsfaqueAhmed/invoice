import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/constants/app_decorations.dart';
import '../../../../core/constants/gaps.dart';
import '../../../../core/widgets/app_card.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  String get _status {
    if (controller.product.stock == 0) return 'outofstock';
    if (controller.product.stock <= 10) return 'lowstock';
    return 'instock';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = controller.product;

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
          onPressed: Get.back,
        ),
        title: Text(
          'InvoiceFlow',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: colors.textSecondary),
            onPressed: () {
              controller.onEdit();
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: BoxDecoration(
          color: colors.cardBg,
          boxShadow: AppDecorations.bottomSheetShadow,
        ),
        child: Row(
          children: [
            OutlinedButton.icon(
              onPressed: controller.onShare,
              icon: const Icon(Icons.share_outlined, size: 18),
              label: const Text('Share'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDecorations.borderRadiusSM,
                ),
              ),
            ),
            Gaps.h12,
            Expanded(
              // flex: 3,
              child: ElevatedButton.icon(
                onPressed: controller.onAddToInvoice,
                icon: const Icon(Icons.add_circle_rounded, size: 18),
                label: const Text('Add to Invoice'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  minimumSize: const Size(0, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDecorations.borderRadiusSM,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero image ──────────────────────────────────
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLowest,
                    borderRadius: AppDecorations.borderRadiusXL,
                    boxShadow: AppDecorations.cardShadow(
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                  child: product.image.isNotEmpty
                      ? ClipRRect(
                          borderRadius: AppDecorations.borderRadiusXL,
                          child: Image.file(
                            File(product.image),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Icon(
                                Icons.inventory_2_rounded,
                                color: colors.outlineVariant,
                                size: 80,
                              );
                            },
                          ),
                        )
                      : Icon(Icons.inventory_2_rounded,
                          size: 80, color: colors.outlineVariant),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _StatusBadge(status: _status, colors: colors),
                ),
              ],
            ),

            Gaps.v16,

            Text(
              'SKU: ${product.sku}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            Gaps.v4,
            Text(
              product.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),

            Gaps.v16,

            // ── Metrics ─────────────────────────────────────
            Row(children: [
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stock Level',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gaps.v4,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${product.stock}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          Gaps.h4,
                          Text('units',
                              style: TextStyle(
                                  fontSize: 11, color: colors.outline)),
                        ],
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
                        'Unit Price',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gaps.v4,
                      Text(
                        product.sellingPrice.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),

            Gaps.v12,

            // ── Total inventory value ────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: AppDecorations.borderRadiusMD,
                boxShadow: AppDecorations.buttonShadow(colors.primary),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Inventory Value',
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              colors.onPrimaryContainer.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gaps.v4,
                      Text(
                        '\$${(product.stock * product.sellingPrice).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: colors.onPrimaryContainer,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.onPrimaryContainer.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.account_balance_wallet_rounded,
                        color: colors.onPrimaryContainer, size: 26),
                  ),
                ],
              ),
            ),

            Gaps.v20,

            // ── Details card ────────────────────────────────
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  Gaps.v8,
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : 'No description provided.',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  Gaps.v12,
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 11,
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              product.category,
                              style: TextStyle(
                                  fontSize: 13, color: colors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: colors.outlineVariant.withValues(alpha: 0.5),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tax Rate',
                              style: TextStyle(
                                fontSize: 11,
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '8.5%',
                              style: TextStyle(
                                  fontSize: 13, color: colors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Gaps.v20,

            // ── Recent invoices ──────────────────────────────
            /* Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Invoices',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            Gaps.v8,
            ...controller.recentInvoices.map(
              (inv) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  child: Row(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: AppDecorations.avatarDecoration(
                          color: colors.secondaryContainer),
                      child: Icon(Icons.description_outlined,
                          color: colors.onSecondaryContainer, size: 20),
                    ),
                    Gaps.h12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inv['number'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            '${inv['date']} • ${inv['qty']} units',
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          inv['amount'],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: colors.textPrimary,
                          ),
                        ),
                        Gaps.v4,
                        StatusBadge(
                          status: StatusBadge.fromString(inv['status']),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),*/
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final AppColorBase colors;

  const _StatusBadge({required this.status, required this.colors});

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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: AppDecorations.chipDecoration(bg: bg),
      child: Row(children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ]),
    );
  }
}
