import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/model/user.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/translations/localization_service.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}

class SignUpController extends GetxController {
  var isValidatedUserName = false;
  var isValidatedEmail = false;
  var isValidatedFullname = false;
  var isValidatedPassword = false;
  var isValidatedConfirmPassword = false;

  final _isSignUpProgressing = false.obs;
  bool get isSignUpProgressing => this._isSignUpProgressing.value;
  set isSignUpProgressing(bool value) =>
      this._isSignUpProgressing.value = value;

  final _isSingUpWithSocialNetwork = false.obs;
  bool get isSingUpWithSocialNetwork => this._isSingUpWithSocialNetwork.value;
  set isSingUpWithSocialNetwork(bool value) =>
      this._isSingUpWithSocialNetwork.value = value;

  final _username = ''.obs;
  String get username => this._username.value;
  set username(String value) => this._username.value = value;

  final _fullName = ''.obs;
  String get fullName => this._fullName.value;
  set fullName(String value) => this._fullName.value = value;

  final _email = ''.obs;
  String get email => this._email.value;
  set email(String value) => this._email.value = value;

  final _password = ''.obs;
  String get password => this._password.value;
  set password(String value) => this._password.value = value;

  final _confirmPassword = ''.obs;
  String get confirmPassword => this._confirmPassword.value;
  set confirmPassword(String value) => this._confirmPassword.value = value;

  final _signUpErrorMessage = Rx<String?>(null);
  String? get signUpErrorMessage => this._signUpErrorMessage.value;
  set signUpErrorMessage(String? value) =>
      this._signUpErrorMessage.value = value;

  final Rx<SocialNetwork?> _socialNetworkSignup = SocialNetwork.LINE.obs;
  SocialNetwork? get socialNetworkSignup => this._socialNetworkSignup.value;
  set socialNetworkSignup(SocialNetwork? value) =>
      this._socialNetworkSignup.value = value;

  final _socialNetworkSignupUserID = Rx<String?>(null);
  String? get socialNetworkSignupUserID =>
      this._socialNetworkSignupUserID.value;
  set socialNetworkSignupUserID(String? value) =>
      this._socialNetworkSignupUserID.value = value;

  TextEditingController? _userNameController =
      new TextEditingController(text: "").obs();
  TextEditingController? get userNameController => this._userNameController;
  set userNameController(TextEditingController? value) =>
      this._userNameController = value;
  @override
  void onInit() {
    super.onInit();

    getUUserID();
    // If signup with social network, it will be received an user information
    var _userArgs = Get.arguments as User?;
    if (_userArgs != null) {
      isSingUpWithSocialNetwork = true;
      fullName = _userArgs.fullName!;
      email = _userArgs.email!;
      socialNetworkSignup = _userArgs.socialNetwork;
    }
    update();
  }

  String? validateFullName(String? value) {
    // update value
    fullName = value?.trim() ?? '';

    // validate value
    if (fullName.isEmpty) {
      isValidatedFullname = false;
      return 'fullname_not_alow_empty'.tr;
    }

    if (fullName.length > 50) {
      isValidatedFullname = false;
      return 'full_name_length_greater_less50'.tr;
    }

    isValidatedFullname = true;
    return null;
  }

  String? validateUsername(String? value) {
    // update value
    username = value?.trim() ?? '';

    // validate value
    if (username.isEmpty) {
      isValidatedUserName = false;
      return 'username_not_alow_empty'.tr;
    }
    isValidatedUserName = true;
    return null;
  }

  String? validateEmail(String? value) {
    // update value
    email = value?.trim() ?? '';

    // validate value
    if (email.isEmpty) {
      isValidatedEmail = false;
      return 'email_not_alow_empty'.tr;
    }
    var _isValidEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!_isValidEmail) {
      isValidatedEmail = false;
      return 'email_invalid'.tr;
    }
    isValidatedEmail = true;
    return null;
  }

  String? validatePassword(String? value) {
    // update value
    password = value?.trim() ?? '';

    // validate value
    if (password.isEmpty) {
      isValidatedPassword = false;
      return 'password_not_alow_empty'.tr;
    }
    if (password.length < 8) {
      isValidatedPassword = false;
      return 'password_must_at_least_8_characters'.tr;
    }
    if (!RegExp(r".*[a-zA-Z]+.*").hasMatch(password)) {
      isValidatedPassword = false;
      return 'password_must_contain_at_least_1_leter'.tr;
    }
    if (!RegExp(r".*[0-9]+.*").hasMatch(password)) {
      isValidatedPassword = false;
      return 'password_must_contain_at_least_1_number'.tr;
    }
    isValidatedPassword = true;
    return null;
  }

  String? validateConfirmPassword(String? value) {
    // update value
    confirmPassword = value?.trim() ?? '';

    // validate value
    if (password.isEmpty) {
      isValidatedConfirmPassword = true;
      return null;
    }
    if (confirmPassword.isEmpty) {
      isValidatedConfirmPassword = false;
      return 'please_confirm_password'.tr;
    }
    if (confirmPassword != password) {
      isValidatedConfirmPassword = false;
      return 'confirm_password_does_not_match'.tr;
    }
    isValidatedConfirmPassword = true;
    return null;
  }

  Future<bool> letsSignUp() async {
    signUpErrorMessage = null;
    isSignUpProgressing = true;

    var _currentTime = DateTime.now().millisecondsSinceEpoch;
    var _locale = LocalizationService.locale;

    /// Call Service Register
    var _userTmp = User(
        uUserID: username,
        password: password,
        fullName: fullName,
        email: email);
    if (isSingUpWithSocialNetwork) {
      _userTmp.provider = socialNetworkSignup.toString().split('.')[1];
      _userTmp.providerUserID = socialNetworkSignupUserID;
    }
    final _signUpResult = await GolfApi()
        .signUp(_userTmp, "$_currentTime", _locale.languageCode.toLowerCase());

    isSignUpProgressing = false;

    /// Handle Register result
    if (_signUpResult.data != null) {
      /// Save Register Information to SharePreference
      SupportUtils.prefs.setBool(HAS_LOGINED, true);
      SupportUtils.prefs.setString(
          AUTH,
          base64Url.encode(
              utf8.encode("${_signUpResult.data!.uUserID}:$_currentTime")));
      SupportUtils.prefs.setString(USERNAME, _signUpResult.data!.uUserID!);
      SupportUtils.prefs
          .setString(USER_FULLNAME, _signUpResult.data!.fullName!);
      SupportUtils.prefs.setString(USER_EMAIL, _signUpResult.data!.email!);
      SupportUtils.prefs.setInt(USER_ID, _signUpResult.data!.userID!);
      SupportUtils.prefs.setString(USER_PHONE, _signUpResult.data!.phone!);
      SupportUtils.prefs
          .setString(USER_AVATAR, _signUpResult.data!.imagesPaths!);
      SupportUtils.prefs
          .setString(USER_PROVIDDER_ID, _signUpResult.data!.providerUserID!);
      SupportUtils.prefs
          .setInt(VERIFIED_EMAIL, _signUpResult.data!.confirmEmail!);
      SupportUtils.prefs.setInt(VERIFY_TIME_MILI, 0);

      // subscribeToTopic
      FirebaseMessaging.instance.subscribeToTopic(
          'notification-golfsystem-user' +
              _signUpResult.data!.userID.toString());
      FirebaseMessaging.instance
          .subscribeToTopic('notification-golfsystem-all');

      // change language
      SupportUtils.prefs
          .setString(APP_LANGUAGE_CODE, _signUpResult.data!.languageCode!);
      LocalizationService.changeLocale();

      return true;
    } else {
      if (_signUpResult.getException == null) {
        /// User existed, cannot sign up
        if (_signUpResult.status == 403) {
          _signUpResult
              .setException(ApplicationError.withMessage('account_existed'.tr));
        }

        if (_signUpResult.status == 404) {
          _signUpResult.setException(
              ApplicationError.withMessage('email_already_exists'.tr));
        }

        /// There is some problem, cannot signup account
        if (_signUpResult.status == 405) {
          _signUpResult
              .setException(ApplicationError.withMessage('cannot_signup'.tr));
        }

        /// If exception still null, let's define exception to applciation exception
        if (_signUpResult.getException == null) {
          _signUpResult.setException(ApplicationError.withCode(
              ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
        }
      }
      signUpErrorMessage = _signUpResult.getException?.getErrorMessage();
      return false;
    }
  }

  Future<void> getUUserID() async {
    try {
      final _result = await GolfApi().getUUserID();
      if (_result.data != null) {
        username = _result.data!;
        userNameController!.text = _result.data!;
      } else {
        signUpErrorMessage = 'application_error'.tr;
        Get.back();
      }
    } on PlatformException catch (error) {
      signUpErrorMessage =
          error.code.isNullEmptyOrWhitespace ? 'application_error'.tr : error.code;
      Get.back();
    }
  }
}
