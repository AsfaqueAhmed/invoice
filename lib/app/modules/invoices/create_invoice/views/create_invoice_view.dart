import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/constants/app_decorations.dart';
import '../../../../core/constants/gaps.dart';
import '../../../../core/constants/padding.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/create_invoice_controller.dart';

class CreateInvoiceView extends GetView<CreateInvoiceController> {
  const CreateInvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
          onPressed: Get.back,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Invoice',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            Text(
              'INV #${controller.invoiceNo}',
              style: TextStyle(
                fontSize: 11,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            width: 36,
            height: 36,
            margin: AppMargin.right12,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child:
                Icon(Icons.business_rounded, color: colors.primary, size: 20),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        decoration: BoxDecoration(
          color: colors.cardBg,
          boxShadow: AppDecorations.bottomSheetShadow,
        ),
        child: Row(children: [
          IconButton(
            icon: Icon(Icons.print_outlined, color: cs.secondary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share_outlined, color: cs.secondary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(() => ElevatedButton.icon(
                  onPressed:
                      controller.isSaving.value ? null : controller.onSave,
                  icon: controller.isSaving.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save_rounded, size: 18),
                  label: Text(
                      controller.isSaving.value ? 'Saving...' : 'Save Invoice'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppDecorations.borderRadiusMD,
                    ),
                  ),
                )),
          ),
        ]),
      ),
      body: SingleChildScrollView(
        padding: AppPadding.all20,
        child: Column(children: [
          // ── Customer selector ──────────────────────────────
          Row(children: [
            Expanded(
              child: AppCard(
                onTap: controller.onSelectCustomer,
                child: Row(children: [
                  Icon(Icons.person_add_outlined, color: colors.primary),
                  Gaps.h8,
                  Obx(() => Text(
                        controller.selectedCustomer.value.isEmpty
                            ? 'Select Customer'
                            : controller.selectedCustomer.value,
                        style: TextStyle(
                          color: controller.selectedCustomer.value.isEmpty
                              ? colors.textTertiary
                              : colors.textPrimary,
                          fontSize: 15,
                        ),
                      )),
                  const Spacer(),
                  Icon(Icons.expand_more_rounded, color: colors.outline),
                ]),
              ),
            ),
            Gaps.h12,
            GestureDetector(
              onTap: controller.onSelectCustomer,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: AppDecorations.borderRadiusMD,
                  boxShadow: AppDecorations.buttonShadow(colors.primary),
                ),
                child: Icon(Icons.add_rounded, color: colors.onPrimary),
              ),
            ),
          ]),

          Gaps.v16,

          // ── Product search ─────────────────────────────────
          AppTextField(
            hintText: 'Search product or enter SKU...',
            controller: controller.searchController,
            onChanged: controller.onSearch,
            prefixIcon: Icon(Icons.search_rounded, color: colors.primary),
            suffixIcon:
                Icon(Icons.qr_code_scanner_rounded, color: colors.outline),
          ),

          Gaps.v20,

          // ── Items header ───────────────────────────────────
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'ADDED ITEMS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Gaps.v10,

          // ── Items list ─────────────────────────────────────
          Obx(() => Column(
                children: List.generate(controller.items.length, (i) {
                  final item = controller.items[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'SKU: ${item['sku']}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline_rounded,
                                  color: colors.error),
                              onPressed: () => controller.removeItem(i),
                            ),
                          ],
                        ),
                        Gaps.v12,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Qty stepper
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerLow,
                                borderRadius: AppDecorations.borderRadiusFull,
                                border: Border.all(
                                    color:
                                        colors.outlineVariant.withOpacity(0.5)),
                              ),
                              child: Row(children: [
                                GestureDetector(
                                  onTap: () => controller.decrementQty(i),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: colors.cardBg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.remove_rounded,
                                        color: colors.primary, size: 18),
                                  ),
                                ),
                                Obx(() => SizedBox(
                                      width: 40,
                                      child: Text(
                                        '${controller.items[i]['qty']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                    )),
                                GestureDetector(
                                  onTap: () => controller.incrementQty(i),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: colors.cardBg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.add_rounded,
                                        color: colors.primary, size: 18),
                                  ),
                                ),
                              ]),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${item['rate'].toStringAsFixed(2)} / unit',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.textSecondary,
                                  ),
                                ),
                                Obx(() => Text(
                                      '\$${(controller.items[i]['qty'] * item['rate']).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: colors.primary,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ]),
                    ),
                  );
                }),
              )),

          // ── Summary ────────────────────────────────────────
          AppCard(
            child: Column(children: [
              _SummaryRow(
                label: 'Subtotal',
                colors: colors,
                value: Obx(() => Text(
                      '\$${controller.subtotal.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 14, color: colors.textPrimary),
                    )),
              ),
              Gaps.v8,
              _SummaryRow(
                label: 'Discount (%)',
                colors: colors,
                value: SizedBox(
                  width: 70,
                  child: TextFormField(
                    initialValue: controller.discount.value.toString(),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    onChanged: (v) =>
                        controller.discount(double.tryParse(v) ?? 0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colors.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: AppDecorations.borderRadiusXS,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                    ),
                  ),
                ),
              ),
              Gaps.v8,
              _SummaryRow(
                label: 'Amount Paid',
                colors: colors,
                value: SizedBox(
                  width: 110,
                  child: TextFormField(
                    initialValue: controller.amountPaid.value.toString(),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    onChanged: (v) =>
                        controller.amountPaid(double.tryParse(v) ?? 0),
                    decoration: InputDecoration(
                      prefixText: '\$',
                      filled: true,
                      fillColor: colors.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: AppDecorations.borderRadiusXS,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                    ),
                  ),
                ),
              ),
              Divider(
                  height: 20, color: colors.outlineVariant.withOpacity(0.5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  Obx(() => Text(
                        '\$${controller.grandTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                          letterSpacing: -0.5,
                        ),
                      )),
                ],
              ),
              Gaps.v8,
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.errorContainer.withOpacity(0.2),
                  borderRadius: AppDecorations.borderRadiusSM,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DUE AMOUNT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colors.error,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Obx(() => Text(
                          '\$${controller.dueAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colors.error,
                          ),
                        )),
                  ],
                ),
              ),
            ]),
          ),
          Gaps.v16,
        ]),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final Widget value;
  final AppColorBase colors;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, color: colors.textSecondary)),
        value,
      ],
    );
  }
}
