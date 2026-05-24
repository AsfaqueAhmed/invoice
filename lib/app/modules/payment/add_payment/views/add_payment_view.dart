import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:get/get.dart';

import '../controllers/add_payment_controller.dart';

class AddPaymentView extends GetView<AddPaymentController> {
  const AddPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: cs.primary),
            onPressed: Get.back),
        title: Text('Add Payment',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: cs.primary)),
        actions: [
          IconButton(
              icon:
                  Icon(Icons.info_outline_rounded, color: cs.onSurfaceVariant),
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
        child: Obx(() => ElevatedButton.icon(
            onPressed: controller.isSaving.value ? null : controller.onConfirm,
            icon: controller.isSaving.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.check_circle_rounded, size: 20),
            label: Text(
                controller.isSaving.value ? 'Saving...' : 'Confirm Payment'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))))),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            // Amount display
            Column(children: [
              Text('TOTAL AMOUNT',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: cs.secondary,
                      letterSpacing: 1.2)),
              const SizedBox(height: 8),
              Obx(() =>
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('\$',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: cs.primary)),
                    Text(controller.amount.value,
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                            letterSpacing: -1)),
                  ])),
            ]),
            const SizedBox(height: 24),
            // Invoice + Date + Note card
            AppCard(
                child: Column(children: [
              // Invoice selector
              Row(children: [
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: AppColor.tertiaryFixed.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.receipt_long_rounded,
                        color: AppColor.tertiary)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Select Invoice',
                          style: TextStyle(
                              fontSize: 11,
                              color: cs.secondary,
                              fontWeight: FontWeight.w600)),
                      Text('Choose an invoice...',
                          style: TextStyle(color: cs.outline, fontSize: 14)),
                      Text('Outstanding Due: \$0.00',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColor.tertiary,
                              fontWeight: FontWeight.w600)),
                    ])),
                Icon(Icons.expand_more_rounded, color: cs.outlineVariant),
              ]),
              Divider(height: 20, color: cs.outlineVariant.withOpacity(0.4)),
              // Date
              Row(children: [
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child:
                        Icon(Icons.calendar_today_rounded, color: cs.primary)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Payment Date',
                          style: TextStyle(
                              fontSize: 11,
                              color: cs.secondary,
                              fontWeight: FontWeight.w600)),
                      Obx(() => Text(controller.selectedDate.value,
                          style: const TextStyle(fontSize: 14))),
                    ])),
              ]),
              Divider(height: 20, color: cs.outlineVariant.withOpacity(0.4)),
              // Note
              Row(children: [
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: cs.secondaryContainer.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.edit_note_rounded, color: cs.secondary)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Note / Description',
                          style: TextStyle(
                              fontSize: 11,
                              color: cs.secondary,
                              fontWeight: FontWeight.w600)),
                      TextField(
                          controller: controller.noteController,
                          decoration: InputDecoration(
                              hintText: 'Add a short reference...',
                              hintStyle:
                                  TextStyle(color: cs.outline, fontSize: 14),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero)),
                    ])),
              ]),
            ])),
            const SizedBox(height: 20),
            // Payment method
            Align(
                alignment: Alignment.centerLeft,
                child: Text('PAYMENT METHOD',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: cs.secondary,
                        letterSpacing: 1.2))),
            const SizedBox(height: 10),
            Obx(() => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.methods.map((m) {
                  final active = controller.selectedMethod.value == m['label'];
                  return GestureDetector(
                      onTap: () =>
                          controller.selectMethod(m['label'] as String),
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: (MediaQuery.of(context).size.width - 60) / 3,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                              color: active
                                  ? cs.primary.withOpacity(0.08)
                                  : (isDark
                                      ? AppColor.darkSurfaceContainer
                                      : Colors.white),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: active
                                      ? cs.primary
                                      : cs.outlineVariant.withOpacity(0.4),
                                  width: active ? 2 : 1),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8)
                              ]),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(m['icon'] as IconData,
                                    color: active ? cs.primary : cs.secondary,
                                    size: 24),
                                const SizedBox(height: 6),
                                Text(m['label'] as String,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: active
                                            ? cs.primary
                                            : cs.secondary)),
                              ])));
                }).toList())),
            const SizedBox(height: 24),
            // Numpad
            AppCard(
                child: Column(children: [
              // Row 1-3
              ...['123', '456', '789'].map((row) => Padding(
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
                                      onTap: () => controller.pressKey(d)))))
                          .toList()))),
              // Bottom row
              Row(children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _NumKey(
                            label: '.',
                            onTap: () => controller.pressKey('.')))),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _NumKey(
                            label: '0',
                            onTap: () => controller.pressKey('0')))),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                            onTap: controller.backspace,
                            child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                    color: cs.errorContainer.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(14)),
                                child: Icon(Icons.backspace_outlined,
                                    color: cs.error, size: 22))))),
              ]),
            ])),
            const SizedBox(height: 80),
          ])),
    );
  }
}

class _NumKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NumKey({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: 56,
            decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14)),
            child: Center(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600)))));
  }
}
