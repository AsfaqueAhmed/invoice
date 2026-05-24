import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bottom_nav.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          backgroundColor: isDark ? AppColor.darkSurface : AppColor.surface,
          elevation: 0,
          title: Text('Settings',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: cs.primary)),
          actions: [
            Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                    color: cs.secondaryContainer, shape: BoxShape.circle),
                child: Icon(Icons.person_rounded,
                    color: cs.onSecondaryContainer, size: 20)),
          ],
        ),
        SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Business profile card
                      AppCard(
                          child: Row(children: [
                        Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                                color: AppColor.primaryFixed,
                                borderRadius: BorderRadius.circular(16)),
                            child: Icon(Icons.storefront_rounded,
                                color: cs.primary, size: 28)),
                        const SizedBox(width: 14),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              const Text('Nexus Solutions Inc.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                              Text('Pro Plan  •  Active',
                                  style: TextStyle(
                                      fontSize: 12, color: cs.secondary)),
                            ])),
                      ])),
                      const SizedBox(height: 20),
                      // Theme toggle
                      AppCard(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Row(children: [
                              Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                      color: cs.primaryFixed
                                          .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Icon(
                                      isDark
                                          ? Icons.dark_mode_rounded
                                          : Icons.light_mode_rounded,
                                      color: cs.primary)),
                              const SizedBox(width: 12),
                              const Text('Dark Mode',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            ]),
                            Obx(() => Switch.adaptive(
                                value: controller.isDarkMode.value,
                                onChanged: (_) => controller.toggleTheme(),
                                activeTrackColor: cs.primary)),
                          ])),
                      const SizedBox(height: 20),
                      _SectionHeader('Business'),
                      AppCard(
                          child: Column(children: [
                        _SettingsTile(
                            icon: Icons.edit_calendar_outlined,
                            iconBg:
                                AppColor.primaryFixed.withValues(alpha: 0.5),
                            iconColor: AppColor.primary,
                            label: 'Edit Business Info',
                            onTap: controller.onEditBusiness),
                        _Divider(),
                        _SettingsTile(
                            icon: Icons.add_photo_alternate_outlined,
                            iconBg:
                                AppColor.primaryFixed.withValues(alpha: 0.5),
                            iconColor: AppColor.primary,
                            label: 'Change Logo',
                            onTap: controller.onChangeLogo),
                      ])),
                      const SizedBox(height: 20),
                      _SectionHeader('Invoice'),
                      AppCard(
                          child: Column(children: [
                        _SettingsTile(
                            icon: Icons.pin_outlined,
                            iconBg:
                                AppColor.tertiaryFixed.withValues(alpha: 0.6),
                            iconColor: AppColor.tertiary,
                            label: 'Invoice Prefix',
                            sub: 'Current: "INV-"',
                            onTap: controller.onInvoicePrefix),
                        _Divider(),
                        _SettingsTile(
                            icon: Icons.percent_rounded,
                            iconBg: AppColor.tertiaryFixed.withOpacity(0.6),
                            iconColor: AppColor.tertiary,
                            label: 'Tax Settings',
                            onTap: controller.onTaxSettings),
                        _Divider(),
                        _SettingsTile(
                            icon: Icons.payments_outlined,
                            iconBg: AppColor.tertiaryFixed.withOpacity(0.6),
                            iconColor: AppColor.tertiary,
                            label: 'Currency',
                            sub: 'United States Dollar (USD)',
                            onTap: controller.onCurrency),
                      ])),
                      const SizedBox(height: 20),
                      _SectionHeader('Printer'),
                      AppCard(
                          child: _SettingsTile(
                              icon: Icons.bluetooth_rounded,
                              iconBg: AppColor.secondaryFixed.withOpacity(0.6),
                              iconColor: AppColor.secondary,
                              label: 'Bluetooth Printer Setup',
                              sub: 'Not Connected',
                              subColor: AppColor.error,
                              onTap: controller.onBluetoothPrinter)),
                      const SizedBox(height: 20),
                      _SectionHeader('Data'),
                      AppCard(
                          child: _SettingsTile(
                              icon: Icons.cloud_done_outlined,
                              iconBg: cs.primary.withOpacity(0.1),
                              iconColor: cs.primary,
                              label: 'Backup & Restore',
                              sub: 'Last backup: 2 hours ago',
                              onTap: controller.onBackupRestore)),
                      const SizedBox(height: 20),
                      Center(
                          child: Text('InvoiceFlow v2.4.0 (Build 882)',
                              style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      cs.onSurfaceVariant.withOpacity(0.5)))),
                      const SizedBox(height: 80),
                    ]))),
      ]),
    );
  }
}

Widget _SectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Builder(
        builder: (context) => Text(title.toUpperCase(),
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.2))));

Widget _Divider() => Builder(
    builder: (ctx) => Divider(
        height: 1,
        indent: 72,
        color: Theme.of(ctx).colorScheme.outlineVariant.withOpacity(0.4)));

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String label;
  final String? sub;
  final Color? subColor;
  final VoidCallback onTap;

  const _SettingsTile(
      {required this.icon,
      required this.iconBg,
      required this.iconColor,
      required this.label,
      this.sub,
      this.subColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
        leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 22)),
        title: Text(label, style: const TextStyle(fontSize: 15)),
        subtitle: sub != null
            ? Text(sub!,
                style: TextStyle(fontSize: 11, color: subColor ?? cs.secondary))
            : null,
        trailing: Icon(Icons.chevron_right_rounded, color: cs.outline));
  }
}
