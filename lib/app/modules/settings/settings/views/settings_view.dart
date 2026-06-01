import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/constants/app_decorations.dart';
import '../../../../core/constants/gaps.dart';
import '../../../../core/constants/padding.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_card.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.scaffold,
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          pinned: true,
          backgroundColor: colors.surface,
          elevation: 0,
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          actions: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: cs.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded,
                  color: cs.onSecondaryContainer, size: 20),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppPadding.all20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Business profile card ──────────────────────
                Obx(() {
                  final businesses = controller.businesses;
                  if (businesses.isEmpty) {
                    return const SizedBox();
                  }
                  return AppCard(
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: AppDecorations.avatarDecoration(
                            color: colors.chipBlueBg,
                            radius: 16,
                          ),
                          child: businesses.first.logo.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: AppDecorations.borderRadiusMD,
                                  child: Image.file(
                                    File(businesses.first.logo),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) {
                                      return Icon(
                                        Icons.storefront_rounded,
                                        color: colors.primary,
                                        size: 28,
                                      );
                                    },
                                  ),
                                )
                              : Icon(Icons.storefront_rounded,
                                  color: colors.primary, size: 28),
                        ),
                        Gaps.h12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.businesses.isNotEmpty
                                    ? controller.businesses.first.name
                                    : '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                ),
                              ),
                              Text(
                                'Pro Plan  •  Active',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                Gaps.v20,

                // ── Theme toggle ───────────────────────────────
                AppCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: AppDecorations.iconContainer(
                            color: colors.chipBlueBg,
                            size: 12,
                          ),
                          child: Icon(
                            isDark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: colors.primary,
                          ),
                        ),
                        Gaps.h12,
                        Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: colors.textPrimary,
                          ),
                        ),
                      ]),
                      Obx(
                        () => Switch.adaptive(
                          value: controller.isDarkMode.value,
                          onChanged: (_) => controller.toggleTheme(),
                          activeTrackColor: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                Gaps.v20,
                _SectionHeader('Business', colors: colors),

                AppCard(
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.edit_calendar_outlined,
                        iconBg: colors.chipBlueBg,
                        iconColor: colors.primary,
                        label: 'Edit Business Info',
                        colors: colors,
                        onTap: controller.onEditBusiness,
                      ),
                      _Divider(colors: colors),
                      _SettingsTile(
                        icon: Icons.add_photo_alternate_outlined,
                        iconBg: colors.chipBlueBg,
                        iconColor: colors.primary,
                        label: 'Change Logo',
                        colors: colors,
                        onTap: controller.onChangeLogo,
                      ),
                    ],
                  ),
                ),

                Gaps.v20,
                _SectionHeader('Invoice', colors: colors),

                AppCard(
                  child: Column(children: [
                    _SettingsTile(
                      icon: Icons.pin_outlined,
                      iconBg: colors.chipAmberBg,
                      iconColor: colors.chipAmberFg,
                      label: 'Invoice Prefix',
                      sub: 'Current: "INV-"',
                      colors: colors,
                      onTap: controller.onInvoicePrefix,
                    ),
                    _Divider(colors: colors),
                    _SettingsTile(
                      icon: Icons.percent_rounded,
                      iconBg: colors.chipAmberBg,
                      iconColor: colors.chipAmberFg,
                      label: 'Tax Settings',
                      colors: colors,
                      onTap: controller.onTaxSettings,
                    ),
                    _Divider(colors: colors),
                    _SettingsTile(
                      icon: Icons.payments_outlined,
                      iconBg: colors.chipAmberBg,
                      iconColor: colors.chipAmberFg,
                      label: 'Currency',
                      sub: 'United States Dollar (USD)',
                      colors: colors,
                      onTap: controller.onCurrency,
                    ),
                  ]),
                ),

                Gaps.v20,
                _SectionHeader('Printer', colors: colors),

                AppCard(
                  child: _SettingsTile(
                    icon: Icons.bluetooth_rounded,
                    iconBg: colors.chipBlueBg,
                    iconColor: colors.secondary,
                    label: 'Bluetooth Printer Setup',
                    sub: 'Not Connected',
                    subColor: colors.error,
                    colors: colors,
                    onTap: controller.onBluetoothPrinter,
                  ),
                ),

                Gaps.v20,
                _SectionHeader('Data', colors: colors),

                AppCard(
                  child: _SettingsTile(
                    icon: Icons.cloud_done_outlined,
                    iconBg: colors.primaryContainer,
                    iconColor: colors.primary,
                    label: 'Backup & Restore',
                    sub: 'Last backup: 2 hours ago',
                    colors: colors,
                    onTap: controller.onBackupRestore,
                  ),
                ),

                Gaps.v20,

                Center(
                  child: Text(
                    'InvoiceFlow v2.4.0 (Build 882)',
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textTertiary,
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final AppColorBase colors;

  const _SectionHeader(this.title, {required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: colors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final AppColorBase colors;

  const _Divider({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 72,
      color: colors.outlineVariant.withOpacity(0.4),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String label;
  final String? sub;
  final Color? subColor;
  final VoidCallback onTap;
  final AppColorBase colors;

  const _SettingsTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.colors,
    required this.onTap,
    this.sub,
    this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: AppDecorations.iconContainer(color: iconBg, size: 12),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            Gaps.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 15, color: colors.textPrimary),
                  ),
                  sub != null ? Gaps.v4 : const SizedBox.shrink(),
                  sub != null
                      ? Text(
                          sub!,
                          style: TextStyle(
                            fontSize: 11,
                            color: subColor ?? colors.textSecondary,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            Gaps.h8,
            Icon(Icons.chevron_right_rounded, color: colors.outline)
          ],
        ),
      ),
    );
  }
}
