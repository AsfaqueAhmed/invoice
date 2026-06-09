import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_getx_app/core/configs/theme/app_colors.dart';
import 'package:flutter_getx_app/core/constants/app_decorations.dart';
import 'package:flutter_getx_app/core/constants/gaps.dart';
import 'package:flutter_getx_app/core/widgets/app_card.dart';
import '../controllers/backup_restore_controller.dart';

class BackupRestoreView extends GetView<BackupRestoreController> {
  const BackupRestoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.primary),
          onPressed: Get.back,
        ),
        title: Text(
          'Backup & Restore',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colors.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // ── Status banner ─────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.secondaryContainer.withOpacity(0.35),
              borderRadius: AppDecorations.borderRadiusMD,
              border: Border.all(color: colors.outlineVariant.withOpacity(0.3)),
            ),
            child: Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.update_rounded, color: colors.primary),
              ),
              Gaps.h12,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATUS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Last backup: ${controller.lastBackup}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ]),
          ),

          Gaps.v20,

          // ── Export ────────────────────────────────────────
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: AppDecorations.iconContainer(
                      color: colors.chipAmberBg,
                      size: 14,
                    ),
                    child: Icon(Icons.upload_file_rounded,
                        color: colors.chipAmberFg, size: 26),
                  ),
                  Gaps.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Export Backup',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          'Save your data safely to local storage or cloud.',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
                Gaps.v16,
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
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppDecorations.borderRadiusSM,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),

          Gaps.v16,

          // ── Import ────────────────────────────────────────
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: AppDecorations.iconContainer(
                      color: colors.primaryContainer,
                      size: 14,
                    ),
                    child: Icon(Icons.publish_rounded,
                        color: colors.primary, size: 26),
                  ),
                  Gaps.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Import Backup',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          'Restore your data from a previous backup file.',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
                Gaps.v16,
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
                                    strokeWidth: 2, color: colors.primary))
                            : const Icon(Icons.folder_open_rounded, size: 20),
                        label: Text(controller.isImporting.value
                            ? 'Importing...'
                            : 'Import File'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: AppDecorations.borderRadiusSM,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),

          Gaps.v16,

          // ── Auto backup toggle ────────────────────────────
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Auto Backup',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        Gaps.v4,
                        Text(
                          'Ensure your financial data is never lost with automatic daily backups.',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gaps.h12,
                  Obx(() => Switch.adaptive(
                        value: controller.autoBackup.value,
                        onChanged: controller.toggleAutoBackup,
                        activeTrackColor: colors.primary,
                      )),
                ]),
                Divider(
                    height: 20, color: colors.outlineVariant.withOpacity(0.4)),
                Row(children: [
                  Icon(Icons.info_outline_rounded,
                      size: 14, color: colors.textSecondary),
                  Gaps.h6,
                  Text(
                    'Next backup scheduled for tomorrow at 2:00 AM',
                    style: TextStyle(fontSize: 11, color: colors.textSecondary),
                  ),
                ]),
              ],
            ),
          ),

          Gaps.v24,

          // ── Security note ──────────────────────────────────
          Column(children: [
            Icon(Icons.lock_reset_rounded, color: colors.outline, size: 40),
            Gaps.v10,
            Text(
              'Your backup files are encrypted with industry-standard AES-256 bit security before being saved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
          ]),

          const SizedBox(height: 80),
        ]),
      ),
    );
  }
}
