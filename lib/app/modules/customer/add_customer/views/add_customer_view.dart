import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/app/core/widgets/custom_text_field.dart';

import 'package:get/get.dart';

import '../controllers/add_customer_controller.dart';

class AddCustomerView extends GetView<AddCustomerController> {
  const AddCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(Icons.receipt_long_rounded,
                  color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
            const Text(
              'InvoiceFlow',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'New Customer',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Create a professional profile for your client.',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            // Avatar Picker
            Center(
              child: GestureDetector(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
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
                            border: Border.all(color: Colors.white, width: 2),
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
            const Center(
              child: Text(
                'Select profile photo',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Basic Details
            _SectionLabel(label: 'BASIC DETAILS'),
            const SizedBox(height: 12),
            CustomTextFormField(
              title: 'Full Name *',
              hintText: 'John Doe',
              controller: controller.fullNameCtrl,
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              title: 'Business Name (Optional)',
              hintText: 'Acme Corp',
              controller: controller.businessNameCtrl,
              prefixIcon: Icon(Icons.business_outlined),
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              title: 'Email Address',
              hintText: 'john@example.com',
              controller: controller.emailCtrl,
              prefixIcon: Icon(Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              title: 'Phone Number',
              hintText: '+1 (555) 000-0000',
              controller: controller.phoneCtrl,
              prefixIcon: Icon(Icons.phone_outlined),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 28),
            // Address Details
            _SectionLabel(label: 'ADDRESS DETAILS'),
            const SizedBox(height: 12),
            CustomTextFormField(
              title: 'Street Address',
              hintText: '123 Financial Way',
              controller: controller.addressCtrl,
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              title: 'City',
              hintText: 'New York',
              controller: controller.cityCtrl,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    title: 'State / Province',
                    hintText: 'NY',
                    controller: controller.stateCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextFormField(
                    title: 'Postal Code',
                    hintText: '10001',
                    controller: controller.postalCtrl,
                    prefixIcon: Icon(Icons.markunread_mailbox_outlined),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save_rounded, size: 18),
                label: const Text('Save Customer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.0,
      ),
    );
  }
}
