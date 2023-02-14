import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  //to read value of the key
  bool _loadThemeFromBox() => _box.read(_key) ?? false;
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  //to change the theme mode
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
  //to save theme mode after switching and to toggle between two themes
  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);
}
