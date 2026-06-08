import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/app/core/constants/gaps.dart';
import 'package:flutter_getx_app/app/core/constants/padding.dart';
import 'package:flutter_getx_app/app/core/utils/app_validators.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bar.dart';
import 'package:flutter_getx_app/app/core/widgets/app_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/add_customer_provider.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _postalCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final error = await ref.read(addCustomerProvider.notifier).save(
          fullName: _fullNameCtrl.text,
          email: _emailCtrl.text,
          phone: _phoneCtrl.text,
          address: _addressCtrl.text,
          city: _cityCtrl.text,
          stateName: _stateCtrl.text,
          postalCode: _postalCtrl.text,
        );

    if (error != null) {
      Get.snackbar('Error', error, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.back(result: true);
    Get.snackbar(
      'Success',
      'Customer saved!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final state = ref.watch(addCustomerProvider);

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: const CustomAppAppbar(title: 'InvoiceFlow'),
      body: Form(
        key: _formKey,
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
                decoration: AppDecorations.sectionDecoration(context: context),
                padding: AppPadding.page,
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () =>
                            ref.read(addCustomerProvider.notifier).pickAvatar(),
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: colors.outlineVariant.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.primary, width: 2),
                          ),
                          child: state.avatar == null
                              ? Stack(
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
                                              color: colors.white, width: 2),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          color: colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: Image.file(state.avatar!,
                                      fit: BoxFit.cover),
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
                decoration: AppDecorations.sectionDecoration(context: context),
                padding: AppPadding.page,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: 'BASIC DETAILS', colors: colors),
                    Gaps.v12,
                    AppTextField(
                      title: 'Full Name',
                      hintText: 'John Doe',
                      controller: _fullNameCtrl,
                      isRequired: true,
                      validator: AppValidators.validateName,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 8),
                        child: Icon(Icons.person_outline_rounded,
                            size: 20, color: colors.outline),
                      ),
                    ),
                    Gaps.v12,
                    AppTextField(
                      title: 'Email Address',
                      hintText: 'john@example.com',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidators.validateEmail,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 8),
                        child: Icon(Icons.email_outlined,
                            size: 20, color: colors.outline),
                      ),
                    ),
                    Gaps.v12,
                    AppTextField(
                      title: 'Phone Number',
                      hintText: '01XXXXXXXXX',
                      controller: _phoneCtrl,
                      isRequired: true,
                      validator: AppValidators.validatePhone,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 8),
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
                decoration: AppDecorations.sectionDecoration(context: context),
                padding: AppPadding.page,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: 'ADDRESS DETAILS', colors: colors),
                    Gaps.v12,
                    AppTextField(
                      title: 'Street Address',
                      hintText: '123 Financial Way',
                      controller: _addressCtrl,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 8),
                        child: Icon(Icons.location_on_outlined,
                            size: 20, color: colors.outline),
                      ),
                      validator: AppValidators.validateNameOptional,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    Gaps.v12,
                    AppTextField(
                      title: 'City',
                      hintText: 'New York',
                      controller: _cityCtrl,
                      validator: AppValidators.validateNameOptional,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    Gaps.v12,
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            title: 'State / Province',
                            hintText: 'NY',
                            controller: _stateCtrl,
                            validator: AppValidators.validateNameOptional,
                            autoValidateMode: AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        Gaps.h12,
                        Expanded(
                          child: AppTextField(
                            title: 'Postal Code',
                            hintText: '10001',
                            controller: _postalCtrl,
                            keyboardType: TextInputType.number,
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 8),
                              child: Icon(Icons.markunread_mailbox_outlined,
                                  size: 20, color: colors.outline),
                            ),
                            validator: AppValidators.validateNameOptional,
                            autoValidateMode: AutovalidateMode.onUserInteraction,
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
              top: BorderSide(color: colors.outlineVariant.withOpacity(0.3))),
          boxShadow: AppDecorations.bottomSheetShadow,
        ),
        padding: AppPadding.page,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: state.isSaving ? null : _onSave,
            icon: state.isSaving
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.onPrimary,
                    ),
                  )
                : const Icon(Icons.save_rounded, size: 18),
            label: Text(state.isSaving ? 'Saving...' : 'Save Customer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
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
        ),
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
