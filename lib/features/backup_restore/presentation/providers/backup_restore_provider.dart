import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

final backupRestoreProvider =
    NotifierProvider<BackupRestoreNotifier, BackupRestoreState>(
  BackupRestoreNotifier.new,
);

class BackupRestoreState {
  const BackupRestoreState({
    this.autoBackup = true,
    this.isExporting = false,
    this.isImporting = false,
    this.lastBackup = '2 hours ago',
  });

  final bool autoBackup;
  final bool isExporting;
  final bool isImporting;
  final String lastBackup;

  BackupRestoreState copyWith({
    bool? autoBackup,
    bool? isExporting,
    bool? isImporting,
  }) {
    return BackupRestoreState(
      autoBackup: autoBackup ?? this.autoBackup,
      isExporting: isExporting ?? this.isExporting,
      isImporting: isImporting ?? this.isImporting,
      lastBackup: lastBackup,
    );
  }
}

class BackupRestoreNotifier extends Notifier<BackupRestoreState> {
  @override
  BackupRestoreState build() => const BackupRestoreState();

  void toggleAutoBackup(bool value) =>
      state = state.copyWith(autoBackup: value);

  Future<void> onExport() async {
    state = state.copyWith(isExporting: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isExporting: false);
    Get.snackbar('Success', 'Backup exported successfully',
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> onImport() async {
    state = state.copyWith(isImporting: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isImporting: false);
    Get.snackbar('Success', 'Backup restored successfully',
        snackPosition: SnackPosition.BOTTOM);
  }
}
