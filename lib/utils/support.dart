import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/decision_option.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/timezone_db.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';
import 'package:sizer/sizer.dart';
// import 'package:zalo_flutter/zalo_flutter.dart';

import 'color.dart';
import 'constants.dart';

extension TextUtilsStringExtension on String {
  /// Returns true if string is:
  /// - null
  /// - empty
  /// - whitespace string.
  ///
  /// Characters considered "whitespace" are listed [here](https://stackoverflow.com/a/59826129/10830091).
  bool get isNullEmptyOrWhitespace => this.isEmpty || this.trim().isEmpty;
}

extension MapExtension on Map {
  Map copyWith(Map map) {
    Map _result = {};
    for (var key in this.keys) {
      _result[key] = this[key];
    }
    for (var key in map.keys) {
      _result[key] = map[key];
    }
    return _result;
  }
}

extension IntFormat on int {
  String toStringFormatDateTime() {
    var dt = DateTime.fromMillisecondsSinceEpoch(this);
    final DateFormat formatter = DateFormat(
      'yyyy/MM/dd, HH:mm:ss',
      Get.locale.toString(),
    );
    final String formatted = formatter.format(dt);
    return formatted;
  }

  String toStringFormatDate() {
    var dt = DateTime.fromMillisecondsSinceEpoch(this);
    final DateFormat formatter = DateFormat(
      'yyyy/MM/dd EEEE',
      Get.locale.toString(),
    );
    final String formatted = formatter.format(dt);
    return formatted;
  }

  String toStringFormatDateUTC() {
    var dt = DateTime.fromMillisecondsSinceEpoch(this, isUtc: true);
    final DateFormat formatter = DateFormat(
      'yyyy/MM/dd EEEE',
      Get.locale.toString(),
    );
    final String formatted = formatter.format(dt);
    return formatted;
  }

  String toStringFormatSimpleDate() {
    var dt = DateTime.fromMillisecondsSinceEpoch(this);
    final DateFormat formatter = DateFormat(
      'yyyy/MM/dd',
      Get.locale.toString(),
    );
    final String formatted = formatter.format(dt);
    return formatted;
  }

  String toStringFormatSimpleDateUTC() {
    var dt = DateTime.fromMillisecondsSinceEpoch(this, isUtc: true);
    final DateFormat formatter = DateFormat(
      'yyyy/MM/dd',
      Get.locale.toString(),
    );
    final String formatted = formatter.format(dt);
    return formatted;
  }

  String toStringFormatHours() {
    var dt = DateTime.fromMillisecondsSinceEpoch(this);
    final DateFormat formatter = DateFormat('HH:mm', Get.locale.toString());
    final String formatted = formatter.format(dt);
    return formatted;
  }

  String toStringFormatHoursUTC() {
    var dt = DateTime.fromMillisecondsSinceEpoch(this, isUtc: true);
    final DateFormat formatter = DateFormat('HH:mm', Get.locale.toString());
    final String formatted = formatter.format(dt);
    return formatted;
  }

  String toStringFormatCurrency() {
    var _formatCurrency = NumberFormat.currency(locale: 'ja_', symbol: '¥ ');
    _formatCurrency.minimumFractionDigits = 0;
    _formatCurrency.maximumFractionDigits = 4;

    return _formatCurrency.format(this);
  }
}

extension StringExtension on String {
  String toMd5() {
    return md5.convert(utf8.encode(this)).toString();
  }
}

extension DateTimeExtension on DateTime {
  DateTime startOfDay() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime endOfDay() {
    return DateTime(this.year, this.month, this.day, 23, 59, 59);
  }

  DateTime startOfMonth() {
    return DateTime(this.year, this.month, 1);
  }
}

class SupportUtils {
  static late SharedPreferences prefs;

  static Color computeStackingPackageColor(int days) {
    return HSLColor.fromAHSL(1, (290 * (days / 400)), 0.88, 0.57).toColor();
  }

  static String getTimeZoneNameID() {
    var _date = DateTime.now();
    var result = 'SE Asia Standard Time';
    getListTimeZoneID.forEach((key, value) {
      if (value == _date.timeZoneOffset.inMinutes) {
        result = key;
      }
    });
    return result;
  }

  static void showToast(
    String? text, {
    ThemeData? themeData,
    String? title,
    ToastType type = ToastType.INFO,
    IconData? icon,
    bool hasIcon = true,
    int durationMili = 3000,
  }) {
    _showToastWithRetry(
      text,
      themeData: themeData,
      title: title,
      type: type,
      icon: icon,
      hasIcon: hasIcon,
      durationMili: durationMili,
      retryCount: 0,
    );
  }

  static void _showToastWithRetry(
    String? text, {
    ThemeData? themeData,
    String? title,
    ToastType type = ToastType.INFO,
    IconData? icon,
    bool hasIcon = true,
    int durationMili = 3000,
    int retryCount = 0,
  }) {
    print('🔔 Toast attempt ${retryCount + 1}: "$text"');

    // Safety check: ensure context and navigation are ready
    if (Get.context == null) {
      print('⚠️ Context is null, retry: $retryCount');
      // Retry after a short delay if this is the first attempt
      if (retryCount < 5) {
        Future.delayed(Duration(milliseconds: 200), () {
          _showToastWithRetry(
            text,
            themeData: themeData,
            title: title,
            type: type,
            icon: icon,
            hasIcon: hasIcon,
            durationMili: durationMili,
            retryCount: retryCount + 1,
          );
        });
      } else {
        print('❌ Toast failed after 5 retries: Context is null');
      }
      return;
    }

    // Check if the widget tree is fully built by verifying overlay availability
    final navigator = Navigator.maybeOf(Get.context!);
    if (navigator == null) {
      print('⚠️ Navigator is null, retry: $retryCount');
      // Retry after a short delay
      if (retryCount < 5) {
        Future.delayed(Duration(milliseconds: 200), () {
          _showToastWithRetry(
            text,
            themeData: themeData,
            title: title,
            type: type,
            icon: icon,
            hasIcon: hasIcon,
            durationMili: durationMili,
            retryCount: retryCount + 1,
          );
        });
      } else {
        print('❌ Toast failed after 5 retries: Navigator is null');
      }
      return;
    }

    // Check if overlay is available without throwing
    bool hasOverlay = false;
    try {
      final overlay = Overlay.maybeOf(Get.context!);
      hasOverlay = overlay != null;
    } catch (e) {
      print('⚠️ Overlay check error: $e');
      hasOverlay = false;
    }

    // If overlay not available after retries, try using ScaffoldMessenger as fallback
    if (!hasOverlay) {
      print('⚠️ Overlay is not available, retry: $retryCount');
      // Retry after a short delay
      if (retryCount < 5) {
        Future.delayed(Duration(milliseconds: 200), () {
          _showToastWithRetry(
            text,
            themeData: themeData,
            title: title,
            type: type,
            icon: icon,
            hasIcon: hasIcon,
            durationMili: durationMili,
            retryCount: retryCount + 1,
          );
        });
        return;
      } else {
        print('⚠️ Overlay not ready, using ScaffoldMessenger fallback');
        // Use ScaffoldMessenger as fallback
        _showScaffoldSnackbar(
          text,
          themeData: themeData,
          title: title,
          type: type,
          icon: icon,
          hasIcon: hasIcon,
          durationMili: durationMili,
        );
        return;
      }
    }

    print('✅ All checks passed, showing GetX toast');

    Color _textColor;
    Icon _icon;
    themeData ??= Theme.of(Get.context!);
    switch (type) {
      case ToastType.SUCCESSFUL:
        _textColor = GolfColor.GolfPrimaryColor;
        icon = icon ?? Icons.check_circle_outline;
        break;
      case ToastType.ERROR:
        _textColor = Colors.red.shade700;
        icon = icon ?? Icons.error_outline;
        break;
      case ToastType.WARNING:
        _textColor = Colors.deepOrange;
        icon = icon ?? Icons.warning_amber_outlined;
        break;
      default:
        _textColor = themeData.colorScheme.toastTextColor;
        icon = icon ?? Icons.info_outline;
    }
    _icon = Icon(icon, color: _textColor, size: 30);

    try {
      print('📢 Calling Get.snackbar...');
      Get.snackbar(
        title ?? '',
        text ?? '',
        titleText: title == null ? Container() : null,
        messageText: text == null ? Container() : null,
        colorText: _textColor,
        snackPosition: SnackPosition.TOP,
        icon: hasIcon ? _icon : null,
        backgroundColor: Colors.grey.shade400,
        padding: EdgeInsets.all(20),
        borderRadius: 5,
        duration: Duration(milliseconds: durationMili),
        animationDuration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 50, left: 10, right: 10),
      );
      print('✨ Toast shown successfully!');
    } catch (e) {
      print('❌ Failed to show snackbar: $e');
    }
  }

  static void _showScaffoldSnackbar(
    String? text, {
    ThemeData? themeData,
    String? title,
    ToastType type = ToastType.INFO,
    IconData? icon,
    bool hasIcon = true,
    int durationMili = 1500,
  }) {
    if (Get.context == null) {
      print('❌ Cannot show scaffold snackbar: Context is null');
      return;
    }

    themeData ??= Theme.of(Get.context!);

    Color _backgroundColor;
    Color _textColor;
    IconData _iconData;

    switch (type) {
      case ToastType.SUCCESSFUL:
        _backgroundColor = GolfColor.GolfPrimaryColor;
        _textColor = Colors.white;
        _iconData = icon ?? Icons.check_circle_outline;
        break;
      case ToastType.ERROR:
        _backgroundColor = Colors.red.shade700;
        _textColor = Colors.white;
        _iconData = icon ?? Icons.error_outline;
        break;
      case ToastType.WARNING:
        _backgroundColor = Colors.deepOrange;
        _textColor = Colors.white;
        _iconData = icon ?? Icons.warning_amber_outlined;
        break;
      default:
        _backgroundColor = Colors.grey.shade700;
        _textColor = Colors.white;
        _iconData = icon ?? Icons.info_outline;
    }

    try {
      print('📢 Showing GetX snackbar at top...');
      
      Get.snackbar(
        title ?? '',
        text ?? '',
        titleText: title == null || title.isEmpty ? Container() : Text(
          title,
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        messageText: text == null || text.isEmpty ? Container() : Text(
          text,
          style: TextStyle(color: _textColor, fontSize: 13),
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: _backgroundColor,
        icon: hasIcon ? Icon(_iconData, color: _textColor, size: 24) : null,
        duration: Duration(milliseconds: durationMili),
        margin: EdgeInsets.all(10),
        borderRadius: 5,
        padding: EdgeInsets.all(16),
      );
      
      print('✨ GetX snackbar shown successfully!');
    } catch (e) {
      print('❌ Failed to show GetX snackbar: $e');
    }
  }

  static Future<void> letsLogout() async {
    SupportUtils.logoutFacebook();
    SupportUtils.logoutGoogle();
    SupportUtils.logoutLine();
    SupportUtils.logoutZalo();

    // subscribeToTopic
    FirebaseMessaging.instance.unsubscribeFromTopic(
      'notification-golfsystem-user${SupportUtils.prefs.getInt(USER_ID)}',
    );
    FirebaseMessaging.instance.unsubscribeFromTopic(
      'notification-golfsystem-all',
    );

    SupportUtils.prefs.setBool(HAS_LOGINED, false);
    SupportUtils.prefs.setString(AUTH, "");
    SupportUtils.prefs.setString(USERNAME, "");
    SupportUtils.prefs.setString(USER_FULLNAME, "");
    SupportUtils.prefs.setString(USER_EMAIL, "");
    SupportUtils.prefs.setInt(USER_ID, 0);
    SupportUtils.prefs.setString(USER_PHONE, "");
    SupportUtils.prefs.setString(USER_AVATAR, "");
    SupportUtils.prefs.setString(USER_PROVIDDER_ID, "");
    SupportUtils.prefs.setInt(VERIFIED_EMAIL, 0);
    SupportUtils.prefs.setInt(VERIFY_TIME_MILI, 0);

    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      print("Error delete FCM token: " + e.toString());
    }
  }

  static Future<bool> logoutFacebook() async {
    // final accessToken = await FacebookAuth.instance.accessToken;
    // if (accessToken != null) {
    //   await FacebookAuth.instance.logOut();
    // }
    return true;
  }

  static Future<bool> logoutGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    var _isLogined = await _googleSignIn.isSignedIn();
    if (_isLogined) {
      await _googleSignIn.signOut();
    }
    return true;
  }

  static Future<bool> logoutLine() async {
    // var _isLogined = (await LineSDK.instance.currentAccessToken)?.data != null;
    // if (_isLogined) {
    //   await LineSDK.instance.logout();
    // }
    return true;
  }

  static Future<bool> logoutZalo() async {
    // ZaloFlutter.logout();
    return true;
  }

  static void showDecisionDialog(
    String decisionMessage, {
    ThemeData? themeData,
    required List<DecisionOption> lstOptions,
    String? decisionDescription,
  }) {
    themeData ??= Theme.of(Get.context!);

    Get.dialog(
      Container(
        alignment: AlignmentDirectional.center,
        padding: EdgeInsets.all(10.0.sp),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: themeData.colorScheme.backgroundCardColor,
          ),
          padding: EdgeInsets.only(left: 20, top: 35, right: 20, bottom: 15),
          constraints: BoxConstraints(maxWidth: 300.0.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                decisionMessage,
                style: themeData.textTheme.headlineMedium?.copyWith(
                  color: GolfColor.GolfSubColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decisionDescription != null
                  ? Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.0.sp,
                      horizontal: 2.0.sp,
                    ),
                    child: Text(
                      decisionDescription,
                      style: themeData.textTheme.headlineLarge!.copyWith(
                        fontSize: 10.0.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                  : Container(),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:
                          lstOptions.map<Widget>((e) {
                            var _optionTextColor;
                            switch (e.type) {
                              case DecisionOptionType.NORMAL:
                                _optionTextColor = Colors.blue;
                                break;
                              case DecisionOptionType.EXPECTATION:
                                _optionTextColor = Colors.green;
                                break;
                              case DecisionOptionType.WARNING:
                                _optionTextColor = Colors.black;
                                break;
                              case DecisionOptionType.DENIED:
                                _optionTextColor = Colors.red;
                                break;
                            }
                            return TextButton(
                              onPressed: () {
                                if (e.isCompleteDecision) {
                                  Get.back<DecisionOption>(result: e);
                                }
                                if (e.onDecisionPressed != null) {
                                  e.onDecisionPressed!();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.5,
                                  vertical: 1,
                                ),
                                child: Text(
                                  e.title,
                                  style: themeData!.textTheme.titleSmall!
                                      .copyWith(
                                        fontSize: 11.0.sp,
                                        color: _optionTextColor,
                                        fontWeight:
                                            e.isImportant
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  static String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static const needleRegex = r'{#}';
  static const needle = '{#}';
  static final RegExp exp = new RegExp(needleRegex);

  static String interpolate(String string, List l) {
    Iterable<RegExpMatch> matches = exp.allMatches(string);

    assert(l.length == matches.length);

    var i = -1;
    return string.replaceAllMapped(exp, (match) {
      print(match.group(0));
      i = i + 1;
      return '${l[i]}';
    });
  }
}
