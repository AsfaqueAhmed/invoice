import 'package:get/get.dart';

class BackupRestoreController extends GetxController {
  final RxBool autoBackup = true.obs;
  final RxBool isExporting = false.obs;
  final RxBool isImporting = false.obs;
  final lastBackup = '2 hours ago';
  void toggleAutoBackup(bool v) => autoBackup(v);
  Future<void> onExport() async {
    isExporting(true);
    await Future.delayed(const Duration(seconds: 2));
    isExporting(false);
    Get.snackbar('Success', 'Backup exported successfully', snackPosition: SnackPosition.BOTTOM);
  }
  Future<void> onImport() async {
    isImporting(true);
    await Future.delayed(const Duration(seconds: 2));
    isImporting(false);
    Get.snackbar('Success', 'Backup restored successfully', snackPosition: SnackPosition.BOTTOM);
  }
}
