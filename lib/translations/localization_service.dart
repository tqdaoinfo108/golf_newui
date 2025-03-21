import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'en_us_translations.dart';
import 'jp_JP_translations.dart';

class LocalizationService extends Translations {
// locale sẽ được get mỗi khi mới mở app (phụ thuộc vào locale hệ thống hoặc bạn có thể cache lại locale mà người dùng đã setting và set nó ở đây)
  static final locale = _getLocaleFromLanguage();

// fallbackLocale là locale default nếu locale được set không nằm trong những Locale support
  static final fallbackLocale = Locale('en', 'US');

// language code của những locale được support
  static final langCodes = ['en', 'ja'];

// các Locale được support
  static final locales = [Locale('en', 'US'), Locale('ja', '')];

// cái này là Map các language được support đi kèm với mã code của lang đó: cái này dùng để đổ data vào Dropdownbutton và set language mà không cần quan tâm tới language của hệ thống
  static final langs = {'en': 'English', 'ja': '日本語'};

// function change language nếu bạn không muốn phụ thuộc vào ngôn ngữ hệ thống
  static void changeLocale() {
    final locale = _getLocaleFromLanguage();
    Get.updateLocale(locale);
    GolfApi().updateLanguage(locale.languageCode);
  }

  @override
  Map<String, Map<String, String>> get keys => {'en_US': en, 'ja': jp};

  static Locale _getLocaleFromLanguage() {
    var lang = SupportUtils.prefs.getString(APP_LANGUAGE_CODE) ??
        Get.deviceLocale!.languageCode;
    Locale? res;

    for (int i = 0; i < langCodes.length; i++) {
      if (lang == langCodes[i]) {
        res = locales[i];
      }
    }

    if (res == null) {
      res = locales[0];
    }

    if (SupportUtils.prefs.getString(APP_LANGUAGE_CODE) == null) {
      SupportUtils.prefs.setString(APP_LANGUAGE_CODE, res.languageCode);
    }
    return res;
  }
}
