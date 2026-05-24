import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bar.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/core/widgets/custom_text_field.dart';

import 'package:get/get.dart';

import '../controllers/add_customer_controller.dart';

class AddCustomerView extends GetView<AddCustomerController> {
  const AddCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: const CustomAppAppbar(title: 'Add Customer'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Customer',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Create a professional profile for your client.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            // Avatar Picker
            AppCard(
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(Icons.person_rounded,
                                  color: AppColors.textTertiary, size: 40),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt_rounded,
                                    color: Colors.white, size: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      'Select profile photo',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // Basic Details
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel(label: 'BASIC DETAILS'),
                  const SizedBox(height: 12),
                  _Field(
                    label: 'Product Name',
                    child: TextFormField(
                      controller: controller.fullNameCtrl,
                      validator: controller.validateRequired,
                      decoration:
                          _dec('John Doe', Icons.person_outline_rounded, cs),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: 'Business Name (Optional)',
                    child: TextFormField(
                      controller: controller.businessNameCtrl,
                      decoration:
                          _dec('Acme Corp', Icons.business_outlined, cs),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: 'Email Address',
                    child: TextFormField(
                      controller: controller.emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          _dec('john@example.com', Icons.email_outlined, cs),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: 'Phone Number',
                    child: TextFormField(
                      controller: controller.phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration:
                          _dec('+1 (555) 000-0000', Icons.phone_outlined, cs),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Address Details
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel(label: 'ADDRESS DETAILS'),
                  const SizedBox(height: 12),
                  _Field(
                    label: 'Street Address',
                    child: TextFormField(
                      controller: controller.addressCtrl,
                      decoration: _dec(
                          '123 Financial Way', Icons.location_on_outlined, cs),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    label: 'City',
                    child: TextFormField(
                      controller: controller.cityCtrl,
                      decoration: _dec('New York', null, cs),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _Field(
                          label: 'State / Province',
                          child: TextFormField(
                            controller: controller.stateCtrl,
                            decoration: _dec('NY', null, cs),
                          ),
                        ),
                      ),
                      Gaps.h12,
                      Expanded(
                        child: _Field(
                          label: 'Postal Code',
                          child: TextFormField(
                            controller: controller.postalCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _dec(
                                '10001', Icons.markunread_mailbox_outlined, cs),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurfaceContainer : Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, -4))
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: controller.isSaving.value ? null : controller.onSave,
            icon: controller.isSaving.value
                ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.save_rounded, size: 20),
            label:  Text(controller.isSaving.value ? 'Saving...' : 'Save Product'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              textStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
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

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }
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
