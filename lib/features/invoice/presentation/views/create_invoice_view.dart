import 'package:flutter/material.dart';
import 'package:flutter_getx_app/core/extensions/string_extensions.dart';
import 'package:flutter_getx_app/features/customer/domain/models/customer.dart';
import 'package:get/get.dart';

import 'package:flutter_getx_app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/core/constants/gaps.dart';
import 'package:flutter_getx_app/core/constants/padding.dart';
import 'package:flutter_getx_app/core/widgets/app_card.dart';
import '../controllers/create_invoice_controller.dart';
import 'widgets/select_customer_bottom_sheet.dart';

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
          Obx(() {
            return CustomerSection(
              customer: controller.selectedCustomer.value,
              onCustomerSelect: () => Get.bottomSheet(
                SelectCustomerBottomSheet(
                  customers: controller.customers,
                  selectedCustomer: controller.selectedCustomer.value,
                  onSelect: controller.onCustomerSelected,
                  onAddTap: () {
                    Get.back();
                    Get.toNamed('/add-customer');
                  },
                ),
                isScrollControlled: true,
              ),
            );
          }),

          Gaps.v20,

          // ── Items header ───────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Obx(() {
                      return Text(
                        'ADDED ITEMS: ${controller.cartItems.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                          letterSpacing: 1.2,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              ProductSection(
                onAddProduct: () => Get.bottomSheet(
                  _SelectProductBottomSheet(controller: controller),
                  isScrollControlled: true,
                ),
              ),
            ],
          ),
          Gaps.v10,

          // ── Items list ─────────────────────────────────────
          Obx(() => Column(
                children: List.generate(controller.cartItems.length, (i) {
                  final item = controller.cartItems[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      color: colors.surfaceContainerLowest,
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'SKU: ${item.product.sku}',
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
                                        '${controller.cartItems[i].quantity}',
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
                                  '\$${item.product.sellingPrice.toStringAsFixed(2)} / unit',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '\$${(item.quantity * item.product.sellingPrice).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: colors.primary,
                                  ),
                                )
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

class CustomerSection extends StatelessWidget {
  final Customer? customer;
  final VoidCallback onCustomerSelect;

  const CustomerSection({
    super.key,
    this.customer,
    required this.onCustomerSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bool hasCustomer = customer != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Text(
            'CUSTOMER',
            style: textTheme.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onCustomerSelect,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colors.outlineVariant.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: hasCustomer
                        ? colors.primary.withValues(alpha: 0.1)
                        : colors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.outlineVariant,
                      style: BorderStyle.solid,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: hasCustomer
                      ? Text(
                          customer?.name.initials ?? '',
                          style: textTheme.titleLarge?.copyWith(
                            color: colors.primary,
                          ),
                        )
                      : Icon(
                          Icons.person_add_alt,
                          color: colors.secondary,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasCustomer ? customer?.name ?? '' : 'Select Customer',
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        hasCustomer
                            ? customer?.phone ?? ''
                            : 'Tap to choose a customer',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.inverseSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colors.outlineVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProductSection extends StatelessWidget {
  final VoidCallback onAddProduct;

  const ProductSection({super.key, required this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onAddProduct,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: colors.primary,
          ),
          const SizedBox(width: 12),
          Text(
            'Add Product',
            style: textTheme.bodyLarge?.copyWith(
              color: colors.primary,
            ),
          ),
        ],
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

// ── Internal product selector bottom sheet ─────────────────────────
class _SelectProductBottomSheet extends StatelessWidget {
  final CreateInvoiceController controller;

  const _SelectProductBottomSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('Select Product', style: theme.textTheme.titleLarge),
                    const Spacer(),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(() => ListView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      controller: scrollController,
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) {
                        final p = controller.products[index];
                        final selected = controller.cartItems
                            .any((c) => c.product.id == p.id);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: InkWell(
                            onTap: () => controller.onProductSelected(p),
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    selected ? cs.primaryContainer : cs.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      selected ? cs.primary : cs.outlineVariant,
                                ),
                              ),
                              child: Row(children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name,
                                          style: theme.textTheme.titleMedium),
                                      Text(
                                        '\$${p.sellingPrice.toStringAsFixed(2)}  •  Stock: ${p.stock}',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                if (selected)
                                  Icon(Icons.check_circle, color: cs.primary),
                              ]),
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
