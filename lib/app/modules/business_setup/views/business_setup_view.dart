import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/business_setup_controller.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/text_style/app_text_styles.dart';
import '../../../core/constants/gaps.dart';
import '../../../core/constants/padding.dart';

class BusinessSetupView extends GetView<BusinessSetupController> {
  const BusinessSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldLight,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Icon(Icons.business_rounded,
                  color: Colors.white, size: 18),
            ),
            Gaps.h12,
            Text(
              'InvoiceFlow',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.grey500),
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

              // ── Header ──────────────────────────────────────────
              Text(
                'Set up your business',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.grey900,
                ),
              ),
              Gaps.v8,
              Text(
                'Configure your professional profile to start generating beautiful invoices.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
              ),

              Gaps.v24,

              // ── Logo Upload ─────────────────────────────────────
              _LogoUpload(controller: controller),

              Gaps.v16,

              // ── Business Name ───────────────────────────────────
              _FormField(
                label: 'Business Name',
                child: TextFormField(
                  controller: controller.businessNameController,
                  validator: controller.validateBusinessName,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    hint: 'e.g. Acme Studio',
                    prefixIcon: null,
                  ),
                ),
              ),

              Gaps.v16,

              // ── Phone ────────────────────────────────────────────
              _FormField(
                label: 'Phone Number',
                child: TextFormField(
                  controller: controller.phoneController,
                  validator: controller.validatePhone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    hint: '+1 (555) 000-0000',
                    prefixIcon: Icons.call_outlined,
                  ),
                ),
              ),

              Gaps.v16,

              // ── Address ──────────────────────────────────────────
              _FormField(
                label: 'Address',
                child: TextFormField(
                  controller: controller.addressController,
                  validator: controller.validateAddress,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                  decoration: _inputDecoration(
                    hint: '123 Creative Way, Suite 400\nSan Francisco, CA 94103',
                    prefixIcon: Icons.location_on_outlined,
                  ),
                ),
              ),

              Gaps.v16,

              // ── Currency ─────────────────────────────────────────
              _FormField(
                label: 'Primary Currency',
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedCurrency.value,
                    onChanged: controller.onCurrencyChanged,
                    decoration: _inputDecoration(
                      hint: 'Select currency',
                      prefixIcon: Icons.payments_outlined,
                    ),
                    icon: const Icon(Icons.expand_more_rounded,
                        color: AppColors.grey400),
                    items: controller.currencies
                        .map(
                          (c) => DropdownMenuItem(
                            value: c['value'],
                            child: Text(
                              c['label']!,
                              style: AppTextStyles.bodyLarge,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

              Gaps.v24,

              // ── Security Badge ───────────────────────────────────
              _SecurityBadge(),

              Gaps.v24,

              // ── Submit Button ────────────────────────────────────
              Obx(() => _SubmitButton(
                    isLoading: controller.isLoading.value,
                    isSuccess: controller.isSuccess.value,
                    onTap: controller.onSubmit,
                  )),

              Gaps.v32,
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey400),
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: AppColors.grey400, size: 20)
          : null,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

// ─── Logo Upload ─────────────────────────────────────────────────

class _LogoUpload extends StatelessWidget {
  final BusinessSetupController controller;
  const _LogoUpload({required this.controller});

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
            color: file != null ? Colors.transparent : AppColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.grey300,
              width: 1.5,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: file != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.file(file, fit: BoxFit.cover),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
                    Gaps.v12,
                    Text(
                      'Logo Upload (Optional)',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                    Gaps.v4,
                    Text(
                      'PNG, JPG up to 5MB',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey400,
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

// ─── Form Field Wrapper ───────────────────────────────────────────

class _FormField extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.grey500,
              letterSpacing: 0.4,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

// ─── Security Badge ───────────────────────────────────────────────

class _SecurityBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: AppColors.primary,
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
                    color: AppColors.grey900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v4,
                Text(
                  'Your business data is encrypted and never shared with third parties.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey500,
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

// ─── Submit Button ────────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final bool isSuccess;
  final VoidCallback onTap;

  const _SubmitButton({
    required this.isLoading,
    required this.isSuccess,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ElevatedButton(
          onPressed: (isLoading || isSuccess) ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isSuccess ? AppColors.success : AppColors.primary,
            disabledBackgroundColor:
                isSuccess ? AppColors.success : AppColors.primary.withOpacity(0.7),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99),
            ),
            elevation: 4,
            shadowColor: AppColors.primary.withOpacity(0.3),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : isSuccess
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded,
                            size: 20),
                        Gaps.h8,
                        Text(
                          'Setup Complete!',
                          style: AppTextStyles.titleMedium
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Complete Setup',
                          style: AppTextStyles.titleMedium
                              .copyWith(color: Colors.white),
                        ),
                        Gaps.h8,
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
        ),
      ),
    );
  }
}

// ─── Missing style shims ──────────────────────────────────────────

extension on AppTextStyles {
  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      );
}
