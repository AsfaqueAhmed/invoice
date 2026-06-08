import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/constants/padding.dart';
import 'package:flutter_getx_app/app/core/extensions/string_extensions.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/data/entities/customer_entity.dart';
import 'package:flutter_getx_app/app/data/entities/product_entity.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/create_invoice_provider.dart';
import '../widgets/select_item_bottom_sheet.dart';

class CreateInvoiceScreen extends ConsumerWidget {
  const CreateInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;
    final cart = ref.watch(createInvoiceProvider);
    final notifier = ref.read(createInvoiceProvider.notifier);

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
              'INV #${cart.invoiceNo}',
              style: TextStyle(fontSize: 11, color: colors.textSecondary),
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
            child: ElevatedButton.icon(
              onPressed: cart.isSaving
                  ? null
                  : () async {
                      final error = await notifier.save();
                      if (error != null) {
                        Get.snackbar('Error', error,
                            snackPosition: SnackPosition.BOTTOM);
                        return;
                      }
                      Get.back(result: true);
                      Get.snackbar('Success', 'Invoice saved!',
                          snackPosition: SnackPosition.BOTTOM);
                    },
              icon: cart.isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save_rounded, size: 18),
              label: Text(cart.isSaving ? 'Saving...' : 'Save Invoice'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDecorations.borderRadiusMD,
                ),
              ),
            ),
          ),
        ]),
      ),
      body: SingleChildScrollView(
        padding: AppPadding.all20,
        child: Column(children: [
          _CustomerSection(
            customer: cart.selectedCustomer,
            onTap: () => _openCustomerPicker(context, ref),
          ),
          Gaps.v20,

          // ── Items header ───────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  'ADDED ITEMS: ${cart.items.length}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              _AddProductButton(onTap: () => _openProductPicker(context, ref)),
            ],
          ),
          Gaps.v10,

          // ── Items list ─────────────────────────────────────
          Column(
            children: List.generate(cart.items.length, (index) {
              final item = cart.items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _InvoiceItemCard(
                  item: item,
                  colors: colors,
                  onIncrement: () => notifier.incrementQty(index),
                  onDecrement: () => notifier.decrementQty(index),
                  onRemove: () => notifier.removeItem(index),
                ),
              );
            }),
          ),

          // ── Summary ────────────────────────────────────────
          AppCard(
            child: Column(children: [
              _SummaryRow(
                label: 'Subtotal',
                colors: colors,
                value: Text(
                  '\$${cart.subtotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14, color: colors.textPrimary),
                ),
              ),
              Gaps.v8,
              _SummaryRow(
                label: 'Discount (%)',
                colors: colors,
                value: SizedBox(
                  width: 70,
                  child: TextFormField(
                    key: ValueKey(cart.invoiceNo),
                    initialValue: cart.discountPercent.toString(),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    onChanged: (v) =>
                        notifier.setDiscountPercent(double.tryParse(v) ?? 0),
                    decoration: _amountFieldDecoration(colors),
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
                    key: ValueKey(cart.invoiceNo),
                    initialValue: cart.amountPaid.toString(),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    onChanged: (v) =>
                        notifier.setAmountPaid(double.tryParse(v) ?? 0),
                    decoration:
                        _amountFieldDecoration(colors, prefixText: '\$'),
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
                  Text(
                    '\$${cart.grandTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
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
                    Text(
                      '\$${cart.dueAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.error,
                      ),
                    ),
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

  InputDecoration _amountFieldDecoration(AppColorBase colors,
      {String? prefixText}) {
    return InputDecoration(
      prefixText: prefixText,
      filled: true,
      fillColor: colors.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: AppDecorations.borderRadiusXS,
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    );
  }

  void _openCustomerPicker(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(createInvoiceProvider.notifier);
    Get.bottomSheet(
      Consumer(
        builder: (context, ref, _) {
          final customers = ref.watch(availableCustomersProvider);
          final selected = ref.watch(createInvoiceProvider).selectedCustomer;
          return AppSelectBottomSheet<CustomerEntity>(
            title: 'Select Customer',
            items: customers.valueOrNull ?? [],
            selectedItem: selected,
            onSelect: (customer) {
              notifier.selectCustomer(customer);
              Get.back();
            },
            addTitle: 'Add New Customer',
            addSubtitle: 'Create a profile for a new client',
            onAddTap: () async {
              await Get.toNamed(Routes.ADD_CUSTOMER);
              ref.invalidate(availableCustomersProvider);
            },
            titleBuilder: (c) => c.name,
            subtitleBuilder: (c) => c.phone,
            avatarBuilder: (c) => c.name.initials,
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _openProductPicker(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(createInvoiceProvider.notifier);
    Get.bottomSheet(
      Consumer(
        builder: (context, ref, _) {
          final products = ref.watch(availableProductsProvider);
          return AppSelectBottomSheet<ProductEntity>(
            title: 'Select Product',
            items: products.valueOrNull ?? [],
            selectedItem: null,
            onSelect: (product) {
              final added = notifier.addProduct(product);
              if (added) {
                Get.back();
              } else {
                Get.snackbar('Warning', 'Product already added.',
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
            addTitle: 'Add Product',
            addSubtitle: 'Update invoice by adding this product',
            onAddTap: () async {
              await Get.toNamed(Routes.ADD_PRODUCT);
              ref.invalidate(availableProductsProvider);
            },
            titleBuilder: (c) => c.name,
            subtitleBuilder: (c) => '${c.category} | ${c.sku} | qty:${c.stock}',
            filePathBuilder: (c) => c.image.notNullNotEmpty ? c.image! : '',
            avatarBuilder: (c) =>
                c.name.initials.isEmpty ? 'U' : c.name.initials,
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}

class _CustomerSection extends StatelessWidget {
  const _CustomerSection({required this.customer, required this.onTap});

  final CustomerEntity? customer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasCustomer = customer != null;

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
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: colors.outlineVariant.withOpacity(0.2)),
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
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  alignment: Alignment.center,
                  child: hasCustomer
                      ? Text(
                          customer?.name.initials ?? '',
                          style: textTheme.titleLarge
                              ?.copyWith(color: colors.primary),
                        )
                      : Icon(Icons.person_add_alt, color: colors.secondary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasCustomer ? customer!.name : 'Select Customer',
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        hasCustomer
                            ? customer!.phone
                            : 'Tap to choose a customer',
                        style: textTheme.bodySmall
                            ?.copyWith(color: colors.inverseSurface),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: colors.outlineVariant),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AddProductButton extends StatelessWidget {
  const _AddProductButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: colors.primary),
          const SizedBox(width: 12),
          Text('Add Product',
              style: textTheme.bodyLarge?.copyWith(color: colors.primary)),
        ],
      ),
    );
  }
}

class _InvoiceItemCard extends StatelessWidget {
  const _InvoiceItemCard({
    required this.item,
    required this.colors,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final ProductEntity item;
  final AppColorBase colors;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: colors.surfaceContainerLowest,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  'SKU: ${item.sku}',
                  style: TextStyle(fontSize: 11, color: colors.textSecondary),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: colors.error),
              onPressed: onRemove,
            ),
          ],
        ),
        Gaps.v12,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: AppDecorations.borderRadiusFull,
                border:
                    Border.all(color: colors.outlineVariant.withOpacity(0.5)),
              ),
              child: Row(children: [
                _QtyButton(
                  icon: Icons.remove_rounded,
                  colors: colors,
                  onTap: onDecrement,
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    '${item.quantity}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                _QtyButton(
                  icon: Icons.add_rounded,
                  colors: colors,
                  onTap: onIncrement,
                ),
              ]),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${item.sellingPrice.toStringAsFixed(2)} / unit',
                  style: TextStyle(fontSize: 11, color: colors.textSecondary),
                ),
                Text(
                  '\$${((item.quantity ?? 0) * item.sellingPrice).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton(
      {required this.icon, required this.colors, required this.onTap});

  final IconData icon;
  final AppColorBase colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: colors.cardBg, shape: BoxShape.circle),
        child: Icon(icon, color: colors.primary, size: 18),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.colors,
  });

  final String label;
  final Widget value;
  final AppColorBase colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: colors.textSecondary)),
        value,
      ],
    );
  }
}
