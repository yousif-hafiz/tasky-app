import 'package:flutter/material.dart';
import 'package:tasky/core/constans/storage_key.dart';

import '../services/preferences_manager.dart';

class ThemeController {
  /// static → متغير عام للتطبيق كله
  //
  // final → ما يتغيرش المرجع، بس القيمة تتغير
  //
  // ValueNotifier → تحديث UI تلقائي
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.dark,
  );

  init() {
    bool result = PreferencesManager().getBool(StorageKey.theme) ?? true;
    themeNotifier.value = result ? ThemeMode.dark : ThemeMode.light;
    /*if (result == true) {
      themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }*/
  }

  static toggleTheme() async {
    if (themeNotifier.value == ThemeMode.dark) {
      themeNotifier.value = ThemeMode.light;
      await PreferencesManager().setBool(StorageKey.theme, false);
    } else {
      themeNotifier.value = ThemeMode.dark;
      await PreferencesManager().setBool(StorageKey.theme, true);
    }
  }

  static bool isDark() => themeNotifier.value == ThemeMode.dark;

  static bool isLight() => themeNotifier.value == ThemeMode.light;
}
