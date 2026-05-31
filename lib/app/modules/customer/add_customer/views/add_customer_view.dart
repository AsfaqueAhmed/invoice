import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/constants/gaps.dart';
import '../../../../core/constants/padding.dart';
import '../../../../core/constants/app_decorations.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/add_customer_controller.dart';

class AddCustomerView extends GetView<AddCustomerController> {
  const AddCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: const CustomAppAppbar(title: 'InvoiceFlow'),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: AppPadding.all20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Customer',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              Gaps.v4,
              Text(
                'Create a professional profile for your client.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: colors.textSecondary,
                ),
              ),
              Gaps.v24,

              // ── Avatar Picker ────────────────────────────────
              Container(
                decoration:
                    AppDecorations.sectionDecoration(context: context),
                padding: AppPadding.page,
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: colors.outlineVariant
                                .withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: colors.primary, width: 2),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.person_rounded,
                                  color: colors.textTertiary,
                                  size: 40,
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: colors.white,
                                        width: 2),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    color: colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gaps.v6,
                    Center(
                      child: Text(
                        'Select profile photo',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gaps.v24,

              // ── Basic Details ────────────────────────────────
              Container(
                decoration:
                    AppDecorations.sectionDecoration(context: context),
                padding: AppPadding.page,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: 'BASIC DETAILS',
                        colors: colors),
                    Gaps.v12,
                    AppTextField(
                      title: 'Full Name',
                      hintText: 'John Doe',
                      controller: controller.fullNameCtrl,
                      isRequired: true,
                      validator: controller.validateRequired,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 8),
                        child: Icon(Icons.person_outline_rounded,
                            size: 20, color: colors.outline),
                      ),
                    ),
                    Gaps.v12,
                    AppTextField(
                      title: 'Business Name (Optional)',
                      hintText: 'Acme Corp',
                      controller: controller.businessNameCtrl,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 8),
                        child: Icon(Icons.business_outlined,
                            size: 20, color: colors.outline),
                      ),
                    ),
                    Gaps.v12,
                    AppTextField(
                      title: 'Email Address',
                      hintText: 'john@example.com',
                      controller: controller.emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 8),
                        child: Icon(Icons.email_outlined,
                            size: 20, color: colors.outline),
                      ),
                    ),
                    Gaps.v12,
                    AppTextField(
                      title: 'Phone Number',
                      hintText: '+1 (555) 000-0000',
                      controller: controller.phoneCtrl,
                      isRequired: true,
                      validator: controller.validateRequired,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 8),
                        child: Icon(Icons.phone_outlined,
                            size: 20, color: colors.outline),
                      ),
                    ),
                  ],
                ),
              ),

              Gaps.v24,

              // ── Address Details ──────────────────────────────
              Container(
                decoration:
                    AppDecorations.sectionDecoration(context: context),
                padding: AppPadding.page,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: 'ADDRESS DETAILS',
                        colors: colors),
                    Gaps.v12,
                    AppTextField(
                      title: 'Street Address',
                      hintText: '123 Financial Way',
                      controller: controller.addressCtrl,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            left: 12, right: 8),
                        child: Icon(Icons.location_on_outlined,
                            size: 20, color: colors.outline),
                      ),
                    ),
                    Gaps.v12,
                    AppTextField(
                      title: 'City',
                      hintText: 'New York',
                      controller: controller.cityCtrl,
                    ),
                    Gaps.v12,
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            title: 'State / Province',
                            hintText: 'NY',
                            controller: controller.stateCtrl,
                          ),
                        ),
                        Gaps.h12,
                        Expanded(
                          child: AppTextField(
                            title: 'Postal Code',
                            hintText: '10001',
                            controller: controller.postalCtrl,
                            keyboardType: TextInputType.number,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 8),
                              child: Icon(
                                  Icons.markunread_mailbox_outlined,
                                  size: 20,
                                  color: colors.outline),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Gaps.v20,
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.cardBg,
          border: Border(
              top: BorderSide(
                  color: colors.outlineVariant.withOpacity(0.3))),
          boxShadow: AppDecorations.bottomSheetShadow,
        ),
        padding: AppPadding.page,
        child: Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isSaving.value
                    ? null
                    : controller.onSave,
                icon: controller.isSaving.value
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.onPrimary,
                        ),
                      )
                    : const Icon(Icons.save_rounded, size: 18),
                label: Text(
                  controller.isSaving.value
                      ? 'Saving...'
                      : 'Save Customer',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDecorations.borderRadiusLG,
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final AppColorBase colors;

  const _SectionLabel({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: colors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }
}
