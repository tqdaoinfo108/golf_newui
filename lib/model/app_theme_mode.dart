import 'package:flutter/material.dart';

class AppThemeMode {
  String code;
  String name;
  ThemeMode value;

  AppThemeMode(this.code, this.name, this.value);

  @override
  bool operator ==(Object other) {
    return other is AppThemeMode && this.code == other.code;
  }

  @override
  int get hashCode => super.hashCode;
}
