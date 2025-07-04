import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar ApplicationAppBar(
  BuildContext context,
  String title, {
  Color? backgroundColor,
  Future<bool> Function()? onBackPressed,
}) {
  return AppBar(
    titleSpacing: 0,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
      onPressed: () {
        if (onBackPressed != null) {
          onBackPressed.call().then((res) {
            if (res) {
              Get.back();
            }
          });
        } else {
          Get.back();
        }
      },
    ),
    title: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall!.copyWith(color: Colors.white),
    ),
  );
}

AppBar ApplicationAppBarLarge(
  BuildContext context,
  String title, {
  Color? backgroundColor,
  Future<bool> Function()? onBackPressed,
}) {  
  return AppBar(
    titleSpacing: 0,
    toolbarHeight: kToolbarHeight,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
      onPressed: () {
        if (onBackPressed != null) {
          onBackPressed.call().then((res) {
            if (res) {
              Get.back();
            }
          });
        } else {
          Get.back();
        }
      },
    ),
    title: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall!.copyWith(color: Colors.white),
    ),
  );
}
