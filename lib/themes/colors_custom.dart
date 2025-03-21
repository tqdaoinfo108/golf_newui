import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/utils/color.dart';

extension MyColorScheme on ColorScheme {
  Color get navigationIconColor => Get.isDarkMode
      ? GolfColor.NavigationBackgroundLightColor
      : GolfColor.NavigationIconBlackColor;

  Color get backgroundCardColor => Get.isDarkMode
      ? GolfColor.BackgroundCardDarkColor
      : GolfColor.BackgroundCardLightColor;

  Color get backgroundToastColor => Get.isDarkMode
      ? GolfColor.BackgroundCardLightColor
      : GolfColor.BackgroundCardDarkColor;

  Color get backgroundDisabledCardColor => Get.isDarkMode
      ? GolfColor.BackgroundDisableCardDarkColor
      : GolfColor.BackgroundDisableCardLightColor;

  Color get iconColor =>
      Get.isDarkMode ? GolfColor.TextDarkColor : GolfColor.TextLightColor;

  Color get toastTextColor =>
      Get.isDarkMode ? GolfColor.TextLightColor : GolfColor.TextDarkColor;

  Color get slotPickerBackgroundColor => Color.fromARGB(100, 199, 216, 223);
}
