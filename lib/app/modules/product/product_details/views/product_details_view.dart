import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/modules/product/product_details/views/widgets/app_section_header.dart';
import 'package:flutter_getx_app/app/modules/product/product_list/model/product_model.dart';
import 'package:flutter_getx_app/app/modules/product/product_list/views/widgets/app_status_chip.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.productDetails;

    return _ProductDetailContent(product: product);
  }
}

class _ProductDetailContent extends StatelessWidget {
  final ProductModel product;

  const _ProductDetailContent({required this.product});

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
    final dateFmt = DateFormat('MMM dd, yyyy');
    final colors = _stockColors;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(Icons.receipt_long_rounded,
                  color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
            const Text(
              'InvoiceFlow',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                color: AppColors.textPrimary, size: 20),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  color: const Color(0xFFF3F4F6),
                  child: product.imageUrl != null
                      ? Image.network(product.imageUrl!, fit: BoxFit.cover)
                      : const Center(
                          child: Icon(Icons.inventory_2_outlined,
                              size: 60, color: AppColors.textTertiary),
                        ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: AppStatusChip(
                    label: product.stockStatus.label,
                    bg: colors.$1,
                    fg: colors.$2,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SKU
                  Text(
                    'SKU ${product.sku}',
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 12,
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Stock & Price row
                  Row(
                    children: [
                      Expanded(
                        child: _DetailItem(
                          label: 'Stock Level',
                          value: '${product.stockQty} units',
                        ),
                      ),
                      Expanded(
                        child: _DetailItem(
                          label: 'Unit Price',
                          value: fmt.format(product.price),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Total Inventory Value
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Inventory Value',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              fmt.format(product.totalInventoryValue),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.copy_outlined,
                              color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Details section
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (product.description != null)
                    Text(
                      product.description!,
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _DetailItem(
                          label: 'Category',
                          value: product.category.label,
                        ),
                      ),
                      Expanded(
                        child: _DetailItem(
                          label: 'Tax Rate',
                          value: '${product.taxRate}%',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Recent Invoices
                  if (product.recentInvoices.isNotEmpty) ...[
                    AppSectionHeader(
                      title: 'Recent Invoices',
                      actionLabel: 'View All',
                      onAction: () {},
                    ),
                    const SizedBox(height: 12),
                    ...product.recentInvoices.map(
                      (inv) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ProductInvoiceRow(
                          invoice: inv,
                          fmt: fmt,
                          dateFmt: dateFmt,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

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
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ProductInvoiceRow extends StatelessWidget {
  final ProductInvoice invoice;
  final NumberFormat fmt;
  final DateFormat dateFmt;

  const _ProductInvoiceRow({
    required this.invoice,
    required this.fmt,
    required this.dateFmt,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = invoice.status == 'PAID';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.receipt_outlined,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: const TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${dateFmt.format(invoice.date)} • ${invoice.units} units',
                  style: const TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                fmt.format(invoice.amount),
                style: const TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isPaid ? AppColors.chipGreen : AppColors.chipAmber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  invoice.status,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color:
                        isPaid ? AppColors.chipGreenFg : AppColors.chipAmberFg,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
