import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:get/get.dart';

import '../controllers/create_invoice_controller.dart';

class CreateInvoiceView extends GetView<CreateInvoiceController> {
  const CreateInvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
            onPressed: Get.back),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Create Invoice',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface)),
          Text('INV #1024  •  Oct 24, 2023',
              style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
        ]),
        actions: [
          Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh, shape: BoxShape.circle),
              child: Icon(Icons.business_rounded, color: cs.primary, size: 20))
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurfaceContainer : Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4))
            ]),
        child: Row(children: [
          IconButton(
              icon: Icon(Icons.print_outlined, color: cs.secondary),
              onPressed: () {}),
          IconButton(
              icon: Icon(Icons.share_outlined, color: cs.secondary),
              onPressed: () {}),
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
                  label: Text(controller.isSaving.value
                      ? 'Saving...'
                      : 'Save Invoice')))),
        ]),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            // Customer selector
            Row(children: [
              Expanded(
                  child: AppCard(
                      child: Row(children: [
                Icon(Icons.person_add_outlined, color: cs.primary),
                const SizedBox(width: 8),
                Obx(() => Text(
                    controller.selectedCustomer.value.isEmpty
                        ? 'Select Customer'
                        : controller.selectedCustomer.value,
                    style: TextStyle(
                        color: controller.selectedCustomer.value.isEmpty
                            ? cs.onSurfaceVariant
                            : cs.onSurface,
                        fontSize: 15))),
                const Spacer(),
                Icon(Icons.expand_more_rounded, color: cs.onSurfaceVariant),
              ]))),
              const SizedBox(width: 12),
              Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: cs.primary.withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4))
                      ]),
                  child: Icon(Icons.add_rounded, color: Colors.white)),
            ]),
            const SizedBox(height: 16),
            // Product search
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: cs.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16)),
                child: TextField(
                    controller: controller.searchController,
                    onChanged: controller.onSearch,
                    decoration: InputDecoration(
                        hintText: 'Search product or enter SKU...',
                        prefixIcon:
                            Icon(Icons.search_rounded, color: cs.primary),
                        suffixIcon: Icon(Icons.qr_code_scanner_rounded,
                            color: cs.onSurfaceVariant),
                        filled: true,
                        fillColor: isDark
                            ? AppColor.darkSurfaceContainer
                            : Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none)))),
            const SizedBox(height: 20),
            // Items
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Added Items',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cs.secondary,
                        letterSpacing: 1.2))),
            const SizedBox(height: 10),
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
                                    Text(item['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15)),
                                    Text('SKU: ${item['sku']}',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: cs.onSurfaceVariant)),
                                  ]),
                              IconButton(
                                  icon: Icon(Icons.delete_outline_rounded,
                                      color: cs.error),
                                  onPressed: () => controller.removeItem(i)),
                            ]),
                        const SizedBox(height: 12),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Qty stepper
                              Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: cs.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(99),
                                      border: Border.all(
                                          color: cs.outlineVariant
                                              .withOpacity(0.5))),
                                  child: Row(children: [
                                    GestureDetector(
                                        onTap: () => controller.decrementQty(i),
                                        child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                                color: cs.surface,
                                                shape: BoxShape.circle),
                                            child: Icon(Icons.remove_rounded,
                                                color: cs.primary, size: 18))),
                                    Obx(() => SizedBox(
                                        width: 40,
                                        child: Text(
                                            '${controller.items[i]['qty']}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16)))),
                                    GestureDetector(
                                        onTap: () => controller.incrementQty(i),
                                        child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                                color: cs.surface,
                                                shape: BoxShape.circle),
                                            child: Icon(Icons.add_rounded,
                                                color: cs.primary, size: 18))),
                                  ])),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        '\$${item['rate'].toStringAsFixed(2)} / unit',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: cs.onSurfaceVariant)),
                                    Obx(() => Text(
                                        '\$${(controller.items[i]['qty'] * item['rate']).toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: cs.primary))),
                                  ]),
                            ]),
                      ])));
                }))),
            // Summary
            AppCard(
                child: Column(children: [
              _summaryLine('Subtotal', cs,
                  value: Obx(() => Text(
                      '\$${controller.subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14)))),
              const SizedBox(height: 8),
              _summaryLine('Discount (%)', cs,
                  value: SizedBox(
                      width: 70,
                      child: TextField(
                          controller: TextEditingController(
                              text: controller.discount.value.toString()),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          onChanged: (v) =>
                              controller.discount(double.tryParse(v) ?? 0),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: cs.surfaceContainerLow,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8))))),
              const SizedBox(height: 8),
              _summaryLine('Amount Paid', cs,
                  value: SizedBox(
                      width: 110,
                      child: TextField(
                          controller: TextEditingController(
                              text: controller.amountPaid.value.toString()),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          onChanged: (v) =>
                              controller.amountPaid(double.tryParse(v) ?? 0),
                          decoration: InputDecoration(
                              prefixText: '\$',
                              filled: true,
                              fillColor: cs.surfaceContainerLow,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8))))),
              Divider(height: 20, color: cs.outlineVariant),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Grand Total',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Obx(() => Text('\$${controller.grandTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                        letterSpacing: -0.5))),
              ]),
              const SizedBox(height: 8),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: cs.errorContainer.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('DUE AMOUNT',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: cs.error,
                                letterSpacing: 0.8)),
                        Obx(() => Text(
                            '\$${controller.dueAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: cs.error))),
                      ])),
            ])),
            const SizedBox(height: 16),
          ])),
    );
  }

  Widget _summaryLine(String label, ColorScheme cs, {required Widget value}) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant)),
        value
      ]);
}
