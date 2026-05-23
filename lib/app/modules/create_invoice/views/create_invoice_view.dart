import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/configs/text_style/app_text_styles.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/gaps.dart';
import '../../../core/constants/margin.dart';
import '../../../core/constants/padding.dart';
import '../controllers/create_invoice_controller.dart';
import '../models/create_invoice_item.dart';

class CreateInvoiceView extends GetView<CreateInvoiceController> {
  const CreateInvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldLight,
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: AppColors.scaffoldLight.withValues(alpha: 0.92),
        surfaceTintColor: AppColors.scaffoldLight,
        leadingWidth: 64,
        leading: Padding(
          padding: AppPadding.h8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.grey900,
            onPressed: Get.back<void>,
          ),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Invoice',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.grey900,
              ),
            ),
            Text(
              'INV #1024 • Oct 24, 2023',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: AppPadding.right8,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(Icons.business_rounded, color: AppColors.primary),
          ),
          Gaps.h8,
        ],
      ),
      body: Obx(
        () => ListView(
          padding: AppPadding.page.copyWith(bottom: 112),
          children: [
            _CustomerSelector(controller: controller),
            Gaps.v24,
            _ProductSearch(controller: controller),
            Gaps.v24,
            Text(
              'ADDED ITEMS',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.grey600,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v16,
            if (controller.items.isEmpty)
              const _EmptyItems()
            else
              ...controller.items.asMap().entries.map(
                    (entry) => Padding(
                      padding: AppMargin.bottom16,
                      child: _InvoiceItemCard(
                        item: entry.value,
                        onRemove: () => controller.removeItem(entry.key),
                        onDecrease: () =>
                            controller.updateQuantity(entry.key, -1),
                        onIncrease: () =>
                            controller.updateQuantity(entry.key, 1),
                      ),
                    ),
                  ),
            Gaps.v8,
            _InvoiceSummary(controller: controller),
          ],
        ),
      ),
      bottomNavigationBar: _BottomActionBar(controller: controller),
    );
  }
}

class _CustomerSelector extends StatelessWidget {
  const _CustomerSelector({required this.controller});

  final CreateInvoiceController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: controller.selectCustomer,
              child: Container(
                height: 56,
                padding: AppPadding.h16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey300),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: AppColors.primary,
                    ),
                    Gaps.h8,
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.selectedCustomer.value,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.expand_more_rounded,
                      color: AppColors.grey600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Gaps.h16,
        SizedBox(
          width: 56,
          height: 56,
          child: ElevatedButton(
            onPressed: controller.quickAddCustomer,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Icon(Icons.add_rounded),
          ),
        ),
      ],
    );
  }
}

class _ProductSearch extends StatelessWidget {
  const _ProductSearch({required this.controller});

  final CreateInvoiceController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.all8,
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
      ),
      child: TextField(
        controller: controller.productSearchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search product or enter SKU...',
          hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey400),
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColors.primary),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.qr_code_scanner_rounded,
              color: AppColors.grey600,
            ),
            onPressed: controller.scanProduct,
          ),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: AppPadding.h16.add(AppPadding.v16),
        ),
      ),
    );
  }
}

class _InvoiceItemCard extends StatelessWidget {
  const _InvoiceItemCard({
    required this.item,
    required this.onRemove,
    required this.onDecrease,
    required this.onIncrease,
  });

  final CreateInvoiceItem item;
  final VoidCallback onRemove;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.all16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey300.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
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
                      item.name,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.grey900,
                      ),
                    ),
                    Gaps.v4,
                    Text(
                      'SKU: ${item.sku}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline_rounded),
                color: AppColors.error,
              ),
            ],
          ),
          Gaps.v16,
          Row(
            children: [
              _QuantityStepper(
                quantity: item.quantity,
                onDecrease: onDecrease,
                onIncrease: onIncrease,
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatCurrency(item.unitPrice)} / ${item.unitLabel}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  Gaps.v4,
                  Text(
                    _formatCurrency(item.total),
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.all4,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        children: [
          _StepperButton(icon: Icons.remove_rounded, onPressed: onDecrease),
          SizedBox(
            width: 48,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.grey900,
              ),
            ),
          ),
          _StepperButton(icon: Icons.add_rounded, onPressed: onIncrease),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Icon(icon),
        color: AppColors.primary,
      ),
    );
  }
}

class _InvoiceSummary extends StatelessWidget {
  const _InvoiceSummary({required this.controller});

  final CreateInvoiceController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey300.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Subtotal',
            value: _formatCurrency(controller.subtotal),
          ),
          Gaps.v16,
          _EditableSummaryRow(
            label: 'Discount (%)',
            controller: controller.discountController,
            onChanged: (_) => controller.refreshTotals(),
            width: 80,
          ),
          Gaps.v16,
          _EditableSummaryRow(
            label: 'Amount Paid',
            controller: controller.amountPaidController,
            onChanged: (_) => controller.refreshTotals(),
            width: 128,
            prefix: '\$',
          ),
          Gaps.v16,
          const Divider(color: AppColors.grey300),
          Gaps.v16,
          _SummaryRow(
            label: 'Grand Total',
            value: _formatCurrency(controller.grandTotal),
            labelStyle: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.grey900,
            ),
            valueStyle: AppTextStyles.displayLarge.copyWith(
              color: AppColors.primary,
            ),
          ),
          Gaps.v16,
          Container(
            padding: AppPadding.all8,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _SummaryRow(
              label: 'DUE AMOUNT',
              value: _formatCurrency(controller.dueAmount),
              labelStyle: AppTextStyles.labelSmall.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
              valueStyle: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
        ),
        Text(
          value,
          style: valueStyle ??
              AppTextStyles.bodyMedium.copyWith(color: AppColors.grey900),
        ),
      ],
    );
  }
}

class _EditableSummaryRow extends StatelessWidget {
  const _EditableSummaryRow({
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.width,
    this.prefix,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final double width;
  final String? prefix;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
          ),
        ),
        SizedBox(
          width: width,
          height: 40,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            onChanged: onChanged,
            style: AppTextStyles.bodyMedium.copyWith(
              color: prefix == null ? AppColors.primary : AppColors.grey900,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              prefixText: prefix,
              prefixStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
              filled: true,
              fillColor: AppColors.grey100,
              contentPadding: AppPadding.h12,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.controller});

  final CreateInvoiceController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: AppPadding.page.copyWith(top: 8),
        decoration: BoxDecoration(
          color: AppColors.scaffoldLight.withValues(alpha: 0.96),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            _BottomIconAction(
              icon: Icons.print_rounded,
              onPressed: controller.printInvoice,
            ),
            Gaps.h8,
            _BottomIconAction(
              icon: Icons.ios_share_rounded,
              onPressed: controller.shareInvoice,
            ),
            Gaps.h16,
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: controller.saveInvoice,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save Invoice'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    textStyle: AppTextStyles.headlineMedium,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomIconAction extends StatelessWidget {
  const _BottomIconAction({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: AppColors.grey600,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.grey100,
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}

class _EmptyItems extends StatelessWidget {
  const _EmptyItems();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            color: AppColors.grey400,
            size: 40,
          ),
          Gaps.v12,
          Text(
            'No items added',
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.grey900),
          ),
          Gaps.v4,
          Text(
            'Search or scan a product to add it.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

String _formatCurrency(double amount) {
  final whole = amount.round().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < whole.length; i++) {
    final fromRight = whole.length - i;
    buffer.write(whole[i]);
    if (fromRight > 1 && fromRight % 3 == 1) {
      buffer.write(',');
    }
  }

  return '\$${buffer.toString()}.00';
}
