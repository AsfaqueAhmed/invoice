import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/text_style/app_text_styles.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/constants/padding.dart';
import 'package:flutter_getx_app/app/core/utils/app_validators.dart';
import 'package:flutter_getx_app/app/core/widgets/app_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../domain/entities/business_entity.dart';
import '../providers/business_setup_provider.dart';

class BusinessSetupScreen extends ConsumerStatefulWidget {
  const BusinessSetupScreen({super.key});

  @override
  ConsumerState<BusinessSetupScreen> createState() =>
      _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends ConsumerState<BusinessSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  BusinessEntity? get _business => Get.arguments as BusinessEntity?;

  @override
  void initState() {
    super.initState();
    final business = _business;
    if (business != null) {
      _nameCtrl.text = business.name;
      _phoneCtrl.text = business.phone;
      _addressCtrl.text = business.address;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(businessSetupProvider.notifier).loadForEdit(business);
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final error = await ref.read(businessSetupProvider.notifier).submit(
          existing: _business,
          name: _nameCtrl.text,
          phone: _phoneCtrl.text,
          address: _addressCtrl.text,
        );

    if (error != null) {
      Get.snackbar('Error', error, snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final business = _business;
    final state = ref.watch(businessSetupProvider);

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
            icon: Icon(Icons.notifications_outlined,
                color: colors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: AppPadding.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v8,
              Text(
                business == null
                    ? 'Set up your business'
                    : 'Update your business',
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
              _LogoUpload(
                logo: state.logo,
                colors: colors,
                onTap: () => ref.read(businessSetupProvider.notifier).pickLogo(),
              ),
              Gaps.v16,

              // Business Name
              AppTextField(
                title: 'Business Name',
                hintText: 'e.g. Acme Studio',
                isRequired: true,
                controller: _nameCtrl,
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
                controller: _phoneCtrl,
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
                controller: _addressCtrl,
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
                child: DropdownButtonFormField<String>(
                  value: state.currency,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(businessSetupProvider.notifier)
                          .selectCurrency(value);
                    }
                  },
                  decoration: AppDecorations.filledInput(
                    context: context,
                    hintText: 'Select currency',
                    prefixIcon: Icon(Icons.payments_outlined,
                        color: colors.outline, size: 20),
                  ),
                  icon: Icon(Icons.expand_more_rounded, color: colors.outline),
                  dropdownColor: colors.cardBg,
                  items: businessCurrencies
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

              Gaps.v24,

              // Security badge
              _SecurityBadge(colors: colors),

              Gaps.v24,

              // Submit
              _SubmitButton(
                isLoading: state.isLoading,
                isSuccess: state.isSuccess,
                colors: colors,
                onTap: _onSubmit,
              ),

              Gaps.v32,
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoUpload extends StatelessWidget {
  final File? logo;
  final AppColorBase colors;
  final VoidCallback onTap;

  const _LogoUpload({required this.logo, required this.colors, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: logo != null ? Colors.transparent : colors.cardBg,
          borderRadius: AppDecorations.borderRadiusXL,
          border: Border.all(
            color: colors.outlineVariant,
            width: 1.5,
          ),
          boxShadow: AppDecorations.cardShadow(
            Theme.of(context).brightness == Brightness.dark,
          ),
        ),
        child: logo != null
            ? ClipRRect(
                borderRadius: AppDecorations.borderRadiusXL,
                child: Image.file(logo!, fit: BoxFit.cover),
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
      ),
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
              isSuccess ? colors.success : colors.primary.withValues(alpha: 0.7),
          foregroundColor: colors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: AppDecorations.borderRadiusFull,
          ),
          elevation: 4,
          shadowColor: colors.primary.withValues(alpha: 0.3),
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
