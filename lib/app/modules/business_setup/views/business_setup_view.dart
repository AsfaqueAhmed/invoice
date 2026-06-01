import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/utils/app_validators.dart';
import 'package:get/get.dart';

import '../../../core/configs/text_style/app_text_styles.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/gaps.dart';
import '../../../core/constants/padding.dart';
import '../../../core/constants/app_decorations.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controllers/business_setup_controller.dart';

class BusinessSetupView extends GetView<BusinessSetupController> {
  const BusinessSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Icon(Icons.business_rounded,
                  color: colors.onPrimary, size: 18),
            ),
            Gaps.h12,
            Text(
              'InvoiceFlow',
              style: AppTextStyles.titleLarge.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon:
                Icon(Icons.notifications_outlined, color: colors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: AppPadding.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v8,
              Text(
                'Set up your business',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              Gaps.v8,
              Text(
                'Configure your professional profile to start generating beautiful invoices.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              Gaps.v24,

              // Logo upload
              _LogoUpload(controller: controller, colors: colors),
              Gaps.v16,

              // Business Name
              AppTextField(
                title: 'Business Name',
                hintText: 'e.g. Acme Studio',
                isRequired: true,
                controller: controller.businessNameController,
                validator: AppValidators.validateName,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                variant: AppTextFieldVariant.filled,
              ),
              Gaps.v16,

              // Phone
              AppTextField(
                title: 'Phone Number',
                hintText: '01XXXXXXXXX',
                isRequired: true,
                controller: controller.phoneController,
                validator: AppValidators.validatePhone,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.phone,
                prefixIcon:
                    Icon(Icons.call_outlined, color: colors.outline, size: 20),
                variant: AppTextFieldVariant.filled,
              ),
              Gaps.v16,

              // Address
              AppTextField(
                title: 'Address',
                hintText: '123 Creative Way\nSan Francisco, CA 94103',
                isRequired: true,
                controller: controller.addressController,
                validator: AppValidators.validateAddress,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                maxLines: 3,
                minLines: 3,
                prefixIcon: Icon(Icons.location_on_outlined,
                    color: colors.outline, size: 20),
                variant: AppTextFieldVariant.filled,
              ),
              Gaps.v16,

              // Currency
              AppFieldLabel(
                label: 'Primary Currency',
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedCurrency.value,
                    onChanged: controller.onCurrencyChanged,
                    decoration: AppDecorations.filledInput(
                      context: context,
                      hintText: 'Select currency',
                      prefixIcon: Icon(Icons.payments_outlined,
                          color: colors.outline, size: 20),
                    ),
                    icon:
                        Icon(Icons.expand_more_rounded, color: colors.outline),
                    dropdownColor: colors.cardBg,
                    items: controller.currencies
                        .map(
                          (c) => DropdownMenuItem(
                            value: c['value'],
                            child: Text(
                              c['label']!,
                              style: AppTextStyles.bodyLarge
                                  .copyWith(color: colors.textPrimary),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

              Gaps.v24,

              // Security badge
              _SecurityBadge(colors: colors),

              Gaps.v24,

              // Submit
              Obx(() => _SubmitButton(
                    isLoading: controller.isLoading.value,
                    isSuccess: controller.isSuccess.value,
                    colors: colors,
                    onTap: controller.onSubmit,
                  )),

              Gaps.v32,
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoUpload extends StatelessWidget {
  final BusinessSetupController controller;
  final AppColorBase colors;

  const _LogoUpload({required this.controller, required this.colors});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.pickLogo,
      child: Obx(() {
        final file = controller.logoFile.value;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: file != null ? Colors.transparent : colors.cardBg,
            borderRadius: AppDecorations.borderRadiusXL,
            border: Border.all(
              color: colors.outlineVariant,
              width: 1.5,
            ),
            boxShadow: AppDecorations.cardShadow(
              Theme.of(context).brightness == Brightness.dark,
            ),
          ),
          child: file != null
              ? ClipRRect(
                  borderRadius: AppDecorations.borderRadiusXL,
                  child: Image.file(file, fit: BoxFit.cover),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLow,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        color: colors.primary,
                        size: 26,
                      ),
                    ),
                    Gaps.v12,
                    Text(
                      'Logo Upload (Optional)',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    Gaps.v4,
                    Text(
                      'PNG, JPG up to 5MB',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
        );
      }),
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  final AppColorBase colors;

  const _SecurityBadge({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppDecorations.borderRadiusMD,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user_outlined,
              color: colors.primary,
              size: 24,
            ),
          ),
          Gaps.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trusted Security',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v4,
                Text(
                  'Your business data is encrypted and never shared with third parties.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final bool isSuccess;
  final AppColorBase colors;
  final VoidCallback onTap;

  const _SubmitButton({
    required this.isLoading,
    required this.isSuccess,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (isLoading || isSuccess) ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSuccess ? colors.success : colors.primary,
          disabledBackgroundColor:
              isSuccess ? colors.success : colors.primary.withOpacity(0.7),
          foregroundColor: colors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: AppDecorations.borderRadiusFull,
          ),
          elevation: 4,
          shadowColor: colors.primary.withOpacity(0.3),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5))
            : isSuccess
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, size: 20),
                      Gaps.h8,
                      Text('Setup Complete!',
                          style: AppTextStyles.titleMedium
                              .copyWith(color: Colors.white)),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Complete Setup',
                          style: AppTextStyles.titleMedium
                              .copyWith(color: Colors.white)),
                      Gaps.h8,
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
      ),
    );
  }
}
