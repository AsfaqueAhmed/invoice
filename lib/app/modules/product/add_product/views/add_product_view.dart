import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: cs.primary),
            onPressed: Get.back),
        title: Text('Add Product',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: cs.primary)),
        actions: [
          Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  color: cs.surfaceContainerLow, shape: BoxShape.circle),
              child: Icon(Icons.person_rounded, color: cs.primary, size: 18))
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
            onPressed: controller.isSaving.value ? null : controller.onSave,
            icon: controller.isSaving.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.save_rounded, size: 20),
            label:
                Text(controller.isSaving.value ? 'Saving...' : 'Save Product'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))))),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Image upload
              GestureDetector(
                  child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          color: cs.surfaceContainerLow,
                          border: Border.all(
                              color: cs.outlineVariant,
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(24)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined,
                                color: cs.outline, size: 32),
                            const SizedBox(height: 6),
                            Text('Add Image',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: cs.onSurfaceVariant,
                                    fontWeight: FontWeight.w500)),
                          ]))),
              const SizedBox(height: 24),
              // Product name
              _Field(
                  label: 'Product Name',
                  child: TextFormField(
                      controller: controller.nameController,
                      validator: controller.validateRequired,
                      decoration: _dec('e.g. Premium Coffee Beans',
                          Icons.inventory_2_outlined, cs))),
              const SizedBox(height: 16),
              // SKU + Barcode
              Row(children: [
                Expanded(
                    child: _Field(
                        label: 'SKU',
                        child: TextFormField(
                            controller: controller.skuController,
                            decoration: _dec('CF-1002', null, cs)))),
                const SizedBox(width: 12),
                Expanded(
                    child: _Field(
                        label: 'Barcode',
                        child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.barcode_reader,
                                color: cs.primary, size: 18),
                            label: Text('Scan',
                                style: TextStyle(color: cs.primary)),
                            style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)))))),
              ]),
              const SizedBox(height: 16),
              // Price + Stock
              Row(children: [
                Expanded(
                    child: _Field(
                        label: 'Price (\$)',
                        child: TextFormField(
                            controller: controller.priceController,
                            validator: controller.validateRequired,
                            keyboardType: TextInputType.number,
                            decoration:
                                _dec('0.00', Icons.payments_outlined, cs)))),
                const SizedBox(width: 12),
                Expanded(
                    child: _Field(
                        label: 'Stock Qty',
                        child: TextFormField(
                            controller: controller.stockController,
                            keyboardType: TextInputType.number,
                            decoration: _dec('0', Icons.inbox_outlined, cs)))),
              ]),
              const SizedBox(height: 16),
              // Category chips
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Category',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurfaceVariant,
                          letterSpacing: 0.4))),
              const SizedBox(height: 8),
              SizedBox(
                  height: 44,
                  child: Obx(() =>
                      ListView(scrollDirection: Axis.horizontal, children: [
                        ...controller.categories.map((cat) {
                          final active =
                              controller.selectedCategory.value == cat;
                          return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                  onTap: () => controller.onCategorySelect(cat),
                                  child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                          color: active
                                              ? cs.primaryContainer
                                              : cs.surfaceContainerHigh,
                                          borderRadius:
                                              BorderRadius.circular(99)),
                                      child: Text(cat,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: active
                                                  ? cs.onPrimaryContainer
                                                  : cs.onSurfaceVariant)))));
                        }),
                        GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: cs.surfaceContainerLow,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: cs.outlineVariant)),
                                child: Icon(Icons.add_rounded,
                                    color: cs.primary, size: 20))),
                      ]))),
              const SizedBox(height: 16),
              // Description
              _Field(
                  label: 'Description (Optional)',
                  child: TextFormField(
                      controller: controller.descController,
                      maxLines: 3,
                      decoration: _dec(
                          'Add some notes about the product...', null, cs))),
              const SizedBox(height: 16),
              // Preview card
              AppCard(
                  child: Row(children: [
                Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(14)),
                    child: Icon(Icons.inventory_2_rounded,
                        color: cs.onSecondaryContainer)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Inventory Preview',
                          style: TextStyle(
                              fontSize: 11,
                              color: cs.secondary,
                              fontWeight: FontWeight.w600)),
                      const Text('Live Preview',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ])),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(99)),
                    child: const Text('Active',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E7D32)))),
              ])),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String hint, IconData? icon, ColorScheme cs) =>
      InputDecoration(
          hintText: hint,
          prefixIcon:
              icon != null ? Icon(icon, color: cs.outline, size: 20) : null,
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.primary, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: cs.error, width: 1.5)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16));
}

class _Field extends StatelessWidget {
  final String label;
  final Widget child;

  const _Field({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurfaceVariant,
                  letterSpacing: 0.4))),
      child,
    ]);
  }
}
