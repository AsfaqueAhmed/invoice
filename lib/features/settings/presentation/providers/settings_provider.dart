import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

/// Whether dark mode is active. Starts from the platform brightness, then
/// takes control away from the system — exactly like the original controller
/// did in `onReady` — and drives `Get.changeThemeMode` on every toggle.
final isDarkModeProvider = NotifierProvider<DarkModeNotifier, bool>(
  DarkModeNotifier.new,
);

class DarkModeNotifier extends Notifier<bool> {
  @override
  bool build() {
    final isDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    return isDark;
  }

  void toggle() {
    state = !state;
    Get.changeThemeMode(state ? ThemeMode.dark : ThemeMode.light);
  }
}

void onBackupRestore() => Get.toNamed(Routes.BACKUP_RESTORE);
