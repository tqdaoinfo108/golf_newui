import 'package:flutter/material.dart';
import 'package:golf_uiv2/model/app_language.dart';
import 'package:golf_uiv2/translations/localization_service.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:sizer/sizer.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';

class ChangeLanguageScreen extends StatefulWidget {
  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  final lstLanguages = [];
  AppLanguage? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    lstLanguages.clear();

    for (var langCode in LocalizationService.langs.keys) {
      lstLanguages
          .add(AppLanguage(langCode, LocalizationService.langs[langCode]));
    }
    var _selectedLangCode = SupportUtils.prefs.getString(APP_LANGUAGE_CODE);
    selectedLanguage =
        lstLanguages.firstWhere((element) => element.code == _selectedLangCode);

    return Scaffold(
      backgroundColor: GolfColor.GolfPrimaryColor,
      appBar: ApplicationAppBar(context,"back".tr),
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
                children: lstLanguages
                    .map<Widget>((item) => ListTile(
                          title: Text(
                            item.name,
                            style: themeData.textTheme.headlineSmall,
                          ),
                          leading: Radio<AppLanguage>(
                            value: item,
                            groupValue: selectedLanguage,
                            splashRadius: 8.0.w,
                            onChanged: (_newItem) {
                              setState(() {
                                selectedLanguage = _newItem;
                              });
                              SupportUtils.prefs
                                  .setString(APP_LANGUAGE_CODE, _newItem!.code);
                              LocalizationService.changeLocale();
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
