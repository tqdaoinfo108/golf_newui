import 'package:flutter/material.dart';
import 'package:golf_uiv2/model/app_theme_mode.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:sizer/sizer.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';

class ChangeThemeModeScreen extends StatefulWidget {
  @override
  _ChangeThemeModeScreenState createState() => _ChangeThemeModeScreenState();
}

class _ChangeThemeModeScreenState extends State<ChangeThemeModeScreen> {
  final List<AppThemeMode> lstThemeMode = [
    AppThemeMode(
        ThemeModeCode.SYSTEM_MODE, 'system_theme'.tr, ThemeMode.system),
    AppThemeMode(ThemeModeCode.LIGHT_MODE, 'light_theme'.tr, ThemeMode.light),
    AppThemeMode(ThemeModeCode.DARK_MODE, 'dark_theme'.tr, ThemeMode.dark),
  ];

  AppThemeMode? selectedTheme;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    var _selectedThemeModeCode = SupportUtils.prefs.getString(APP_THEME_MODE) ??
        ThemeModeCode.SYSTEM_MODE;
    selectedTheme = lstThemeMode
        .firstWhere((element) => element.code == _selectedThemeModeCode);

    return Scaffold(
      backgroundColor: GolfColor.GolfPrimaryColor,
      appBar: ApplicationAppBar("back".tr),
      body: Container(
          height: double.infinity, // <-----
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.0.w),
                topRight: Radius.circular(6.0.w)),
            color: themeData.colorScheme.backgroundCardColor,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20.0.sp),
              child: Column(
                children: lstThemeMode
                    .map<Widget>((item) => ListTile(
                          title: Text(
                            item.name,
                            style: themeData.textTheme.headlineSmall,
                          ),
                          leading: Radio<AppThemeMode>(
                            value: item,
                            groupValue: selectedTheme,
                            onChanged: (_newItem) {
                              setState(() {
                                selectedTheme = _newItem;
                              });
                              SupportUtils.prefs.setString(
                                  APP_THEME_MODE, selectedTheme!.code);
                              Get.changeThemeMode(selectedTheme!.value);
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          )),
    );
  }
}
