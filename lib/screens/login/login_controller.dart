import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
// import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/model/user.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/translations/localization_service.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:zalo_flutter/zalo_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../router/app_routers.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class LoginController extends GetxController {
  var isValidatedUserName = false;
  var isValidatedPasssword = false;

  @override
  void onReady() {
    super.onReady();
    _isFirstOpenApp.value =
        SupportUtils.prefs.getBool(IS_FIRST_OPEN_APP) ?? false;
    if (!_isFirstOpenApp.value) {
      Get.offAndToNamed(AppRoutes.TERMS_OF_USE);
    }

    if (Platform.isIOS) {
      SignInWithApple.isAvailable().then((res) {
        isAppleIdLoginAvailable = res;
        update();
      });
    }

    getValueConfig();
  }

  Future<void> getValueConfig() async {
    var _result = await GolfApi().getKeyConfigByKey("LoginWithSocial");

    /// Handle result
    if (_result.data != null && _result.data!.isNotEmpty) {
      isHideSocial.value = _result.data == 'true';
      update();
    }
  }

  RxBool isHideSocial = false.obs;

  final _isAppleIdLoginAvailable = false.obs;
  bool get isAppleIdLoginAvailable => this._isAppleIdLoginAvailable.value;
  set isAppleIdLoginAvailable(bool value) =>
      this._isAppleIdLoginAvailable.value = value;

  final _isLoginProgressing = false.obs;
  bool get isLoginProgressing => this._isLoginProgressing.value;
  set isLoginProgressing(bool value) => this._isLoginProgressing.value = value;

  final _userName = ''.obs;
  String get userName => this._userName.value;
  set userName(String value) => this._userName.value = value;

  final _userPassword = ''.obs;
  String get userPassword => this._userPassword.value;
  set userPassword(String value) => this._userPassword.value = value;

  final _loginErrorMessage = Rx<String?>(null);
  String? get loginErrorMessage => this._loginErrorMessage.value;
  set loginErrorMessage(String? value) => this._loginErrorMessage.value = value;

  final _isFirstOpenApp = false.obs;
  bool get isFirstOpenApp => this._isFirstOpenApp.value;

  String? validateUsername(String? username) {
    // update value
    userName = username?.trim() ?? '';

    // validate value
    if (userName.isEmpty) {
      isValidatedUserName = false;
      return 'username_not_alow_empty'.tr;
    }
    isValidatedUserName = true;
    return null;
  }

  String? validatePassword(String? password) {
    // update value
    userPassword = password?.trim() ?? '';

    // validate value
    if (userPassword.isEmpty) {
      isValidatedPasssword = false;
      return 'password_not_alow_empty'.tr;
    }
    isValidatedPasssword = true;
    return null;
  }

  Future<bool> letsLogin() async {
    loginErrorMessage = null;
    isLoginProgressing = true;
    var _currentTime = DateTime.now().millisecondsSinceEpoch;

    /// Call Service Login
    final _loginResult = await GolfApi().login(
      userName,
      userPassword,
      "$_currentTime",
    );

    isLoginProgressing = false;

    /// Handle Login result
    if (_loginResult.data != null) {
      /// Save user information to sharepreferences
      SupportUtils.prefs.setBool(HAS_LOGINED, true);
      SupportUtils.prefs.setString(
        AUTH,
        base64Url.encode(
          utf8.encode("${_loginResult.data!.uUserID}:$_currentTime"),
        ),
      );
      SupportUtils.prefs.setString(USERNAME, _loginResult.data!.uUserID!);
      SupportUtils.prefs.setString(USER_FULLNAME, _loginResult.data!.fullName!);
      SupportUtils.prefs.setString(USER_EMAIL, _loginResult.data!.email!);
      SupportUtils.prefs.setInt(USER_ID, _loginResult.data!.userID!);
      SupportUtils.prefs.setString(USER_PHONE, _loginResult.data!.phone!);
      SupportUtils.prefs.setString(
        USER_AVATAR,
        _loginResult.data!.imagesPaths!,
      );
      SupportUtils.prefs.setInt(
        VERIFIED_EMAIL,
        _loginResult.data!.confirmEmail!,
      );
      SupportUtils.prefs.setInt(VERIFY_TIME_MILI, 0);

      // subscribeToTopic
      FirebaseMessaging.instance.subscribeToTopic(
        'notification-golfsystem-user' + _loginResult.data!.userID.toString(),
      );
      FirebaseMessaging.instance.subscribeToTopic(
        'notification-golfsystem-all',
      );

      // change language
      SupportUtils.prefs.setString(
        APP_LANGUAGE_CODE,
        _loginResult.data!.languageCode!,
      );
      LocalizationService.changeLocale();

      return true;
    } else {
      if (_loginResult.getException == null) {
        /// User not exist or incorrect password
        if (_loginResult.status == 401) {
          _loginResult.setException(
            ApplicationError.withMessage('user_name_or_password_incorrect'.tr),
          );
        }

        /// This user is inactive
        if (_loginResult.status == 402) {
          _loginResult.setException(
            ApplicationError.withMessage('account_has_been_blocked'.tr),
          );
        }

        /// If exception still null, let's define exception to applciation exception
        if (_loginResult.getException == null) {
          _loginResult.setException(
            ApplicationError.withCode(
              ApplicationErrorCode.UNKNOW_APPLICATION_ERROR,
            ),
          );
        }
      }
      loginErrorMessage = _loginResult.getException?.getErrorMessage();
      return false;
    }
  }

  Future<bool> letsLoginBySocialNetwork(User user) async {
    loginErrorMessage = null;
    isLoginProgressing = true;

    var _currentTime = DateTime.now().millisecondsSinceEpoch;
    var _locale = LocalizationService.locale;

    /// Call Service Login
    final _loginResult = await GolfApi().signUp(
      user,
      "$_currentTime",
      _locale.languageCode.toLowerCase(),
    );

    isLoginProgressing = false;

    /// Handle Login result
    if (_loginResult.data != null && _loginResult.status! < 300) {
      /// Save user information to sharepreferences
      SupportUtils.prefs.setBool(HAS_LOGINED, true);
      SupportUtils.prefs.setString(
        AUTH,
        base64Url.encode(
          utf8.encode("${_loginResult.data!.uUserID}:$_currentTime"),
        ),
      );
      SupportUtils.prefs.setString(USERNAME, _loginResult.data!.uUserID!);
      SupportUtils.prefs.setString(USER_FULLNAME, _loginResult.data!.fullName!);
      SupportUtils.prefs.setString(USER_EMAIL, _loginResult.data!.email!);
      SupportUtils.prefs.setInt(USER_ID, _loginResult.data!.userID!);
      SupportUtils.prefs.setString(USER_PHONE, _loginResult.data!.phone!);
      SupportUtils.prefs.setString(
        USER_AVATAR,
        _loginResult.data!.imagesPaths!,
      );
      SupportUtils.prefs.setString(
        USER_PROVIDDER_ID,
        _loginResult.data!.providerUserID!,
      );
      SupportUtils.prefs.setInt(
        VERIFIED_EMAIL,
        _loginResult.data!.confirmEmail!,
      );
      SupportUtils.prefs.setInt(VERIFY_TIME_MILI, 0);

      
      // subscribeToTopic
      FirebaseMessaging.instance.subscribeToTopic(
        'notification-golfsystem-user${_loginResult.data!.userID}',
      );
      FirebaseMessaging.instance.subscribeToTopic(
        'notification-golfsystem-all',
      );
      for (var shopID in _loginResult.data!.lstShopID ?? []) {
        FirebaseMessaging.instance.subscribeToTopic(shopID);
      }
      // change language
      SupportUtils.prefs.setString(
        APP_LANGUAGE_CODE,
        _loginResult.data!.languageCode!,
      );
      LocalizationService.changeLocale();

      return true;
    } else {
      if (_loginResult.getException == null) {
        /// This user is inactive
        if (_loginResult.status == 402) {
          _loginResult.setException(
            ApplicationError.withMessage('account_has_been_blocked'.tr),
          );
        }

        /// User existed, cannot sign up
        if (_loginResult.status == 403) {
          _loginResult.setException(
            ApplicationError.withMessage('account_existed'.tr),
          );
        }

        if (_loginResult.status == 404) {
          _loginResult.setException(
            ApplicationError.withMessage('email_already_exists'.tr),
          );
        }

        /// There is some problem, cannot signup account
        if (_loginResult.status == 405) {
          _loginResult.setException(
            ApplicationError.withMessage('cannot_signup'.tr),
          );
        }

        /// If exception still null, let's define exception to applciation exception
        if (_loginResult.getException == null) {
          _loginResult.setException(
            ApplicationError.withCode(
              ApplicationErrorCode.UNKNOW_APPLICATION_ERROR,
            ),
          );
        }
      }
      loginErrorMessage = _loginResult.getException?.getErrorMessage();
      return false;
    }
  }

  Future<User?> loginFacebook() async {
    User _userTmp = User();
    try {
      // final result = await FacebookAuth.instance.login();

      // if (result.accessToken != null &&
      //     !result.accessToken!.token.isNullEmptyOrWhitespace &&
      //     !result.accessToken!.userId.isNullEmptyOrWhitespace) {
      //   final userData = await FacebookAuth.instance.getUserData();
      //   _userTmp.providerUserID = userData['id'];
      //   _userTmp.fullName = userData['name'];
      //   _userTmp.email = userData['email'];
      //
      //   return _userTmp;
      // } else {
      //   throw Exception();
      // }
    } catch (_) {
      loginErrorMessage = 'login_with_facebook_fail'.tr;
    }
    return null;
  }

  Future<User?> loginGoogle() async {
    User _userTmp = User();

    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
        
      );
      var _googleAcc = await _googleSignIn.signIn();
      if (_googleAcc != null &&
          !_googleAcc.isBlank! &&
          !_googleAcc.id.isNullEmptyOrWhitespace) {
        _userTmp.providerUserID = _googleAcc.id;
        _userTmp.fullName = _googleAcc.displayName;
        _userTmp.email = _googleAcc.email;
      } else {
        throw Exception();
      }
    } catch (e) {
      loginErrorMessage = 'login_with_google_fail'.tr;
      return null;
    }

    return _userTmp;
  }

  Future<User?> loginZalo() async {
    User _userTmp = User();
    String? _accessToken;

    try {
      // final _res = await ZaloFlutter.login(refreshToken: null);
      // _accessToken =
      //     _res?["data"]["accessToken"] ?? _res?["data"]["access_token"];
      //
      // if (_res?['isSuccess'] == true) {
      //   var _zaloAcc = await ZaloFlutter.getUserProfile(
      //     accessToken: (_accessToken ?? ''),
      //   );
      //   if (_zaloAcc != null &&
      //       (_zaloAcc["data"]["id"] as String? ?? "").isNotEmpty &&
      //       (_zaloAcc["data"]["name"] as String? ?? "").isNotEmpty) {
      //     _userTmp.providerUserID = _zaloAcc["data"]["id"] as String?;
      //     _userTmp.fullName = _zaloAcc["data"]["name"] as String?;
      //     _userTmp.email = '';
      //
      //     return _userTmp;
      //   } else {
      //     throw Exception();
      //   }
      // } else {
      //   throw Exception();
      // }
    } catch (_) {
      loginErrorMessage = 'login_with_zalo_fail'.tr;
      return null;
    }
  }

  Future<User?> loginLine() async {
    User _userTmp = User();
    try {
      final result = await LineSDK.instance.login();
      var _userProfile = result.userProfile;

      if (_userProfile != null &&
          !_userProfile.isBlank! &&
          !_userProfile.userId.isNullEmptyOrWhitespace) {
        _userTmp.providerUserID = _userProfile.userId;
        _userTmp.fullName = _userProfile.displayName;
        _userTmp.email = '';
      } else {
        throw Exception();
      }
    } catch (_) {
      loginErrorMessage = 'login_with_line_fail'.tr;
      return null;
    }

    return _userTmp;
  }

  Future<User?> loginAppleID() async {
    User _userTmp = User();
    final rawNonce = SupportUtils.generateNonce();
    final nonce = SupportUtils.sha256ofString(rawNonce);

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      final userEmail = '${appleCredential.email ?? ''}';
      final userId = '${appleCredential.userIdentifier}';

      if (!userId.isNullEmptyOrWhitespace) {
        _userTmp.providerUserID = userId;
        _userTmp.fullName = displayName;
        _userTmp.email = userEmail;
      } else {
        throw Exception();
      }
    } catch (_) {
      loginErrorMessage = 'login_with_apple_fail'.tr;
      return null;
    }

    return _userTmp;
  }
}
