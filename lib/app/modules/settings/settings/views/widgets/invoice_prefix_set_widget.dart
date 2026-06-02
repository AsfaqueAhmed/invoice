import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/widgets/app_text_field.dart';
import 'package:flutter_getx_app/app/modules/settings/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';

class InvoicePrefixSetWidget extends StatelessWidget {
  final SettingsController controller;

  const InvoicePrefixSetWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SafeArea(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.outlineVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Gaps.v8,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Invoice Prefix',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: Icon(Icons.close_rounded, color: colors.primary),
                    ),
                  ],
                ),
                Gaps.v8,
                AppFieldLabel(
                  label: 'Prefix',
                  child: AppTextField(
                    hintText: 'e.g. INV',
                    controller: controller.invoicePrefixController,
                    validator: controller.validateRequired,
                    prefixIcon: Icon(
                      Icons.confirmation_number_outlined,
                      color: colors.outline,
                      size: 20,
                    ),
                  ),
                ),
                Gaps.v48,
                ElevatedButton.icon(
                  onPressed: controller.onSavePrefix,
                  icon: const Icon(Icons.save, size: 20),
                  label: Text(
                    'Save Prefix',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: colors.onPrimary,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Gaps.v12
              ],
            ),
          ),
        ),
      ),
    );
  }
}
