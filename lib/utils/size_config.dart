import 'package:flutter/material.dart';

class SizeConfig {
  late MediaQueryData _mediaQueryData;
  late double screenWidth;
  late double screenHeight;
  double? defaultSize;
  late double heightStatusBar;
  Orientation? orientation;

  static BuildContext? _context;
  static SizeConfig? _staticSizeConfig;

  // void init(BuildContext context) {
  //   _mediaQueryData = MediaQuery.of(context);
  //   screenWidth = _mediaQueryData.size.width;
  //   screenHeight = _mediaQueryData.size.height;
  //   orientation = _mediaQueryData.orientation;
  //   heightStatusBar = _mediaQueryData.padding.top;
  // }

  SizeConfig(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    heightStatusBar = _mediaQueryData.padding.top;
  }

  static SizeConfig? withContext(BuildContext context) {
    if (_context == null ||
        _staticSizeConfig == null ||
        !identical(_context, context)) {
      _context = context;
      _staticSizeConfig = SizeConfig(_context!);
    }
    return _staticSizeConfig;
  }

  // factory SizeConfig() {
  //   return SizeConfig.withContext(Get.context);
  // }

  // Get the proportionate height as per screen size
  double getProportionateScreenHeight(double inputHeight) {
    // 812 is the layout height that designer use
    return (inputHeight / 812.0) * screenHeight;
  }

  // Get the proportionate height as per screen size
  double getProportionateScreenWidth(double inputWidth) {
    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }
}
