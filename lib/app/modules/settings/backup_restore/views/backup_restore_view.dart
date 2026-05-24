import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bar.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';

import 'package:get/get.dart';

import '../controllers/backup_restore_controller.dart';

class BackupRestoreView extends GetView<BackupRestoreController> {
  const BackupRestoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: const CustomAppAppbar(title: 'Backup & Restore'),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            // Status
            Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: cs.secondaryContainer.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.3))),
                child: Row(children: [
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle),
                      child: Icon(Icons.update_rounded, color: cs.primary)),
                  const SizedBox(width: 12),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('STATUS',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: cs.secondary,
                                letterSpacing: 1)),
                        Text('Last backup: ${controller.lastBackup}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                      ]),
                ])),
            const SizedBox(height: 20),
            // Export
            AppCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            color: AppColor.tertiary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.upload_file_rounded,
                            color: AppColor.tertiary, size: 26)),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          const Text('Export Backup',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600)),
                          Text(
                              'Save your data safely to local storage or cloud.',
                              style: TextStyle(
                                  fontSize: 12, color: cs.onSurfaceVariant)),
                        ])),
                  ]),
                  const SizedBox(height: 16),
                  Obx(() => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                          onPressed: controller.isExporting.value
                              ? null
                              : controller.onExport,
                          icon: controller.isExporting.value
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.download_rounded, size: 20),
                          label: Text(controller.isExporting.value
                              ? 'Exporting...'
                              : 'Export Now'),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)))))),
                ])),
            const SizedBox(height: 16),
            // Import
            AppCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14)),
                        child: Icon(Icons.publish_rounded,
                            color: cs.primary, size: 26)),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          const Text('Import Backup',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600)),
                          Text('Restore your data from a previous backup file.',
                              style: TextStyle(
                                  fontSize: 12, color: cs.onSurfaceVariant)),
                        ])),
                  ]),
                  const SizedBox(height: 16),
                  Obx(() => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                          onPressed: controller.isImporting.value
                              ? null
                              : controller.onImport,
                          icon: controller.isImporting.value
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: cs.primary))
                              : const Icon(Icons.folder_open_rounded, size: 20),
                          label: Text(controller.isImporting.value
                              ? 'Importing...'
                              : 'Import File'),
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)))))),
                ])),
            const SizedBox(height: 16),
            // Auto backup toggle
            AppCard(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          const Text('Auto Backup',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                              'Ensure your financial data is never lost with automatic daily backups.',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: cs.onSurfaceVariant,
                                  height: 1.4)),
                        ])),
                    const SizedBox(width: 12),
                    Obx(() => Switch.adaptive(
                        value: controller.autoBackup.value,
                        onChanged: controller.toggleAutoBackup,
                        activeTrackColor: cs.primary)),
                  ]),
                  Divider(
                      height: 20,
                      color: cs.outlineVariant.withValues(alpha: 0.4)),
                  Row(children: [
                    Icon(Icons.info_outline_rounded,
                        size: 14, color: cs.secondary),
                    const SizedBox(width: 6),
                    Text('Next backup scheduled for tomorrow at 2:00 AM',
                        style: TextStyle(fontSize: 11, color: cs.secondary)),
                  ]),
                ])),
            const SizedBox(height: 24),
            // Security note
            Column(children: [
              Icon(Icons.lock_reset_rounded,
                  color: cs.secondary.withValues(alpha: 0.4), size: 40),
              const SizedBox(height: 10),
              Text(
                  'Your backup files are encrypted with industry-standard AES-256 bit security before being saved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      color: cs.secondary.withValues(alpha: 0.7),
                      height: 1.5)),
            ]),
            const SizedBox(height: 16),
          ])),
    );
  }
}
