import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bar.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/core/widgets/custom_cache_network_image.dart';
import 'package:flutter_getx_app/app/core/widgets/status_badge.dart';
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
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = controller.product;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: cs.primary),
            onPressed: Get.back),
        title: Text('InvoiceFlow',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: cs.primary)),
        actions: [
          IconButton(
              icon: Icon(Icons.edit_outlined, color: cs.secondary),
              onPressed: () {})
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurfaceContainer : Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4))
            ]),
        child: Row(children: [
          Expanded(
              child: OutlinedButton.icon(
                  onPressed: controller.onShare,
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('Share'),
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))))),
          const SizedBox(width: 12),
          Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                  onPressed: controller.onAddToInvoice,
                  icon: const Icon(Icons.add_circle_rounded, size: 18),
                  label: const Text('Add to Invoice'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))))),
        ]),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Hero image
            Stack(children: [
              Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                      color: cs.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 16)
                      ]),
                  child: Icon(Icons.inventory_2_rounded,
                      size: 80, color: cs.outlineVariant)),
              Positioned(
                  top: 12, right: 12, child: _statusBadge(p['status'], cs)),
            ]),
            const SizedBox(height: 16),
            Text('SKU: ${p['sku']}',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: cs.secondary,
                    letterSpacing: 0.8)),
            const SizedBox(height: 4),
            Text(p['name'],
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            // Metrics
            Row(children: [
              Expanded(
                  child: AppCard(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    Text('Stock Level',
                        style: TextStyle(
                            fontSize: 11,
                            color: cs.secondary,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('${p['stock']}',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface)),
                          const SizedBox(width: 4),
                          Text('units',
                              style:
                                  TextStyle(fontSize: 11, color: cs.outline)),
                        ]),
                  ]))),
              const SizedBox(width: 12),
              Expanded(
                  child: AppCard(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    Text('Unit Price',
                        style: TextStyle(
                            fontSize: 11,
                            color: cs.secondary,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(p['price'],
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: cs.primary)),
                  ]))),
            ]),
            const SizedBox(height: 12),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: cs.primary.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4))
                    ]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Inventory Value',
                                style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        cs.onPrimaryContainer.withOpacity(0.8),
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text('\$${(p['stock'] * 89).toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: cs.onPrimaryContainer,
                                    letterSpacing: -0.5)),
                          ]),
                      Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              color: cs.onPrimaryContainer.withOpacity(0.15),
                              shape: BoxShape.circle),
                          child: Icon(Icons.account_balance_wallet_rounded,
                              color: cs.onPrimaryContainer, size: 26)),
                    ])),
            const SizedBox(height: 20),
            // Details
            AppCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text('Details',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                      'Sleek aluminum product with premium build quality. Compatible with a wide range of use cases.',
                      style: TextStyle(
                          fontSize: 14,
                          color: cs.onSurfaceVariant,
                          height: 1.5)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: cs.secondary,
                                  fontWeight: FontWeight.w600)),
                          const Text('Hardware / Accessories',
                              style: TextStyle(fontSize: 13)),
                        ]),
                    Container(
                        width: 1,
                        height: 36,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: cs.outlineVariant),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tax Rate',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: cs.secondary,
                                  fontWeight: FontWeight.w600)),
                          const Text('8.5%', style: TextStyle(fontSize: 13)),
                        ]),
                  ]),
                ])),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Recent Invoices',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ]),
            const SizedBox(height: 8),
            ...controller.recentInvoices.map((inv) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppCard(
                      child: Row(children: [
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: cs.secondaryContainer,
                            shape: BoxShape.circle),
                        child: Icon(Icons.description_outlined,
                            color: cs.onSecondaryContainer, size: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(inv['number'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13)),
                          Text('${inv['date']} • ${inv['qty']} units',
                              style: TextStyle(
                                  fontSize: 11, color: cs.onSurfaceVariant)),
                        ])),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(inv['amount'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(height: 4),
                          StatusBadge(
                              status: StatusBadge.fromString(inv['status'])),
                        ]),
                  ])),
                )),
            const SizedBox(height: 80),
          ])),
    );
  }

  Widget _statusBadge(String status, ColorScheme cs) {
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
        child: Row(children: [
          Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
          Text(label,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
        ]));
  }
}
