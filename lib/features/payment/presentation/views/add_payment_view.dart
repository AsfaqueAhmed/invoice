import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_getx_app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/core/constants/gaps.dart';
import 'package:flutter_getx_app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/core/widgets/app_card.dart';
import '../controllers/add_payment_controller.dart';

class AddPaymentView extends GetView<AddPaymentController> {
  const AddPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
          onPressed: Get.back,
        ),
        title: Text(
          'Add Payment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: colors.outline),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        decoration: BoxDecoration(
          color: colors.cardBg,
          boxShadow: AppDecorations.bottomSheetShadow,
        ),
        child: Obx(() => ElevatedButton.icon(
              onPressed:
                  controller.isSaving.value ? null : controller.onConfirm,
              icon: controller.isSaving.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.check_circle_rounded, size: 20),
              label: Text(
                controller.isSaving.value ? 'Saving...' : 'Confirm Payment',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDecorations.borderRadiusMD,
                ),
              ),
            )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // ── Amount display ─────────────────────────────────
          Column(children: [
            Text(
              'TOTAL AMOUNT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            Gaps.v8,
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),
                    Text(
                      controller.amount.value,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                )),
          ]),
          Gaps.v24,

          // ── Invoice + Date + Note ─────────────────────────
          AppCard(
            child: Column(children: [
              // Invoice selector
              Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: AppDecorations.iconContainer(
                    color: colors.chipAmberBg,
                    size: 12,
                  ),
                  child: Icon(Icons.receipt_long_rounded,
                      color: colors.chipAmberFg),
                ),
                Gaps.h12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Invoice',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Choose an invoice...',
                        style:
                            TextStyle(color: colors.outline, fontSize: 14),
                      ),
                      Text(
                        'Outstanding Due: \$0.00',
                        style: TextStyle(
                          fontSize: 10,
                          color: colors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.expand_more_rounded, color: colors.outline),
              ]),
              Divider(
                  height: 20,
                  color: colors.outlineVariant.withOpacity(0.4)),
              // Date
              Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: AppDecorations.iconContainer(
                    color: colors.primaryContainer,
                    size: 12,
                  ),
                  child: Icon(Icons.calendar_today_rounded,
                      color: colors.primary),
                ),
                Gaps.h12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Date',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Obx(() => Text(
                            controller.selectedDate.value,
                            style: TextStyle(
                                fontSize: 14, color: colors.textPrimary),
                          )),
                    ],
                  ),
                ),
              ]),
              Divider(
                  height: 20,
                  color: colors.outlineVariant.withOpacity(0.4)),
              // Note
              Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: AppDecorations.iconContainer(
                    color: colors.secondaryContainer,
                    size: 12,
                  ),
                  child: Icon(Icons.edit_note_rounded,
                      color: colors.textSecondary),
                ),
                Gaps.h12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Note / Description',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextField(
                        controller: controller.noteController,
                        style: TextStyle(color: colors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Add a short reference...',
                          hintStyle: TextStyle(
                              color: colors.outline, fontSize: 14),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ]),
          ),

          Gaps.v20,

          // ── Payment method ────────────────────────────────
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'PAYMENT METHOD',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Gaps.v10,
          Obx(() => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.methods.map((m) {
                  final active =
                      controller.selectedMethod.value == m['label'];
                  return GestureDetector(
                    onTap: () =>
                        controller.selectMethod(m['label'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: (MediaQuery.of(context).size.width - 60) / 3,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: active
                            ? colors.primaryContainer
                            : colors.cardBg,
                        borderRadius: AppDecorations.borderRadiusMD,
                        border: Border.all(
                          color: active
                              ? colors.primary
                              : colors.outlineVariant.withOpacity(0.4),
                          width: active ? 2 : 1,
                        ),
                        boxShadow: AppDecorations.cardShadow(
                          Theme.of(context).brightness == Brightness.dark,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            m['icon'] as IconData,
                            color: active
                                ? colors.primary
                                : colors.textSecondary,
                            size: 24,
                          ),
                          Gaps.v6,
                          Text(
                            m['label'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? colors.primary
                                  : colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )),

          Gaps.v24,

          // ── Numpad ────────────────────────────────────────
          AppCard(
            child: Column(children: [
              ...['123', '456', '789'].map(
                (row) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: row
                        .split('')
                        .map((d) => Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: _NumKey(
                                  label: d,
                                  colors: colors,
                                  onTap: () => controller.pressKey(d),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _NumKey(
                        label: '.',
                        colors: colors,
                        onTap: () => controller.pressKey('.')),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _NumKey(
                        label: '0',
                        colors: colors,
                        onTap: () => controller.pressKey('0')),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: controller.backspace,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: colors.errorContainer.withOpacity(0.3),
                          borderRadius: AppDecorations.borderRadiusSM,
                        ),
                        child: Icon(Icons.backspace_outlined,
                            color: colors.error, size: 22),
                      ),
                    ),
                  ),
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }
}

class _NumKey extends StatelessWidget {
  final String label;
  final AppColorBase colors;
  final VoidCallback onTap;

  const _NumKey(
      {required this.label, required this.colors, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: AppDecorations.borderRadiusSM,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
