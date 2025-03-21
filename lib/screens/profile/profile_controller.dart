import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/services/base_service_core.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/translations/localization_service.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';

class ProfileController extends GetxController {
  var isValidatedEmail = false;
  var isValidatedFullname = false;
  var isValidatedPhone = true;

  final _updatingInfo = false.obs;
  bool get updatingInfo => this._updatingInfo.value;
  set updatingInfo(bool value) => this._updatingInfo.value = value;

  final _availableVerifyTimeLeft = RxInt(-1); // In seconds
  int get availableVerifyTimeLeft => this._availableVerifyTimeLeft.value;
  set availableVerifyTimeLeft(int value) =>
      this._availableVerifyTimeLeft.value = value;

  final _isSentVerify = false.obs;
  bool get isSentVerify => this._isSentVerify.value;
  set isSentVerify(bool value) => this._isSentVerify.value = value;

  final _isVerifiedAccount = false.obs;
  bool get isVerifiedAccount => this._isVerifiedAccount.value;
  set isVerifiedAccount(bool value) => this._isVerifiedAccount.value = value;

  final _editableEmail = false.obs;
  bool get editableEmail => this._editableEmail.value;
  set editableEmail(bool value) => this._editableEmail.value = value;

  final _imagePath = ''.obs;
  String get imagePath => this._imagePath.value;
  set imagePath(String value) => this._imagePath.value = value;

  final _username = ''.obs;
  String get username => this._username.value;
  set username(String value) => this._username.value = value;

  final _phone = ''.obs;
  String get phone => this._phone.value;
  set phone(String value) => this._phone.value = value;

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

  final Rx<SocialNetwork> _socialNetworkSignup = SocialNetwork.LINE.obs;
  SocialNetwork get socialNetworkSignup => this._socialNetworkSignup.value;
  set socialNetworkSignup(SocialNetwork value) =>
      this._socialNetworkSignup.value = value;

  final _socialNetworkSignupUserID = Rx<String?>(null);
  String? get socialNetworkSignupUserID =>
      this._socialNetworkSignupUserID.value;
  set socialNetworkSignupUserID(String? value) =>
      this._socialNetworkSignupUserID.value = value;

  final _isRemoveUser = true.obs;
  bool get isRemoveUser => this._isRemoveUser.value;
  set setIsRemoveUser(bool value) => this._isRemoveUser.value = value;
  // final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    getValueConfig();

    username = SupportUtils.prefs.getString(USERNAME)!;
    fullName = SupportUtils.prefs.getString(USER_FULLNAME)!;
    email = SupportUtils.prefs.getString(USER_EMAIL)!;
    phone = SupportUtils.prefs.getString(USER_PHONE)!;
    imagePath = SupportUtils.prefs.getString(USER_AVATAR)!;
    isVerifiedAccount = SupportUtils.prefs.getInt(VERIFIED_EMAIL) ==
        ConfirmEmailStatus.CONFIRMED;

    editableEmail = email.isEmpty;

    isValidatedEmail = validateEmail(email) == null;
    isValidatedFullname = validateFullName(fullName) == null;
    isValidatedPhone = validatePhone(phone) == null;

    getUserInfo();
    _startTimerVerify();
  }

  Future<void> getValueConfig() async {
    var _result = await GolfApi().getKeyConfigByKey("IsRemoveUser");

    /// Handle result
    if (_result.data != null && _result.data!.isNotEmpty) {
      setIsRemoveUser = _result.data == 'true';
    }
  }

  Future<void> getUserInfo({bool justupdateVerified = false}) async {
    final _ueserInfoResult = await GolfApi().getUserInfo();

    /// Handle Register result
    if (_ueserInfoResult.data != null) {
      if (!justupdateVerified) {
        username = _ueserInfoResult.data!.uUserID!;
        fullName = _ueserInfoResult.data!.fullName!;
        email = _ueserInfoResult.data!.email!;
        phone = _ueserInfoResult.data!.phone!;
        imagePath = _ueserInfoResult.data!.imagesPaths!;
        editableEmail = email.isEmpty;

        /// Save User Information to SharePreference
        SupportUtils.prefs.setString(USERNAME, _ueserInfoResult.data!.uUserID!);
        SupportUtils.prefs
            .setString(USER_FULLNAME, _ueserInfoResult.data!.fullName!);
        SupportUtils.prefs.setString(USER_EMAIL, _ueserInfoResult.data!.email!);
        SupportUtils.prefs.setInt(USER_ID, _ueserInfoResult.data!.userID!);
        SupportUtils.prefs.setString(USER_PHONE, _ueserInfoResult.data!.phone!);
        SupportUtils.prefs
            .setString(USER_AVATAR, _ueserInfoResult.data!.imagesPaths!);
      }

      isVerifiedAccount =
          _ueserInfoResult.data!.confirmEmail == ConfirmEmailStatus.CONFIRMED;
      SupportUtils.prefs
          .setInt(VERIFIED_EMAIL, _ueserInfoResult.data!.confirmEmail!);
    }
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
    // username = value;

    // // validate value
    // if (username.isEmpty) {
    //   isValidatedUserName = false;
    //   return 'username_not_alow_empty'.tr;
    // }
    // isValidatedUserName = true;
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

  String? validatePhone(String? value) {
    // update value
    phone = value?.trim() ?? '';

    // validate value
    if (phone.isNotEmpty) {
      var _isValidPhone = RegExp(
              r"^(0([1-9]{1}-?[1-9]\d{3}|[1-9]{2}-?\d{3}|[1-9]{2}\d{1}-?\d{2}|[1-9]{2}\d{2}-?\d{1})-?\d{4}|0[789]0-?\d{4}-?\d{4}|050-?\d{4}-?\d{4})$")
          .hasMatch(phone);
      if (!_isValidPhone) {
        isValidatedPhone = false;
        return 'phone_invalid'.tr;
      }
    }
    isValidatedPhone = true;
    return null;
  }

  void updateProfile() async {
    updatingInfo = true;
    var _response = await GolfApi().updateProfile(fullName, phone, email);
    if (_response.data != null && _response.data!.userID != null) {
      SupportUtils.prefs.setString(USER_FULLNAME, _response.data!.fullName!);
      SupportUtils.prefs.setString(USER_EMAIL, _response.data!.email!);
      SupportUtils.prefs.setString(USER_PHONE, _response.data!.phone!);
      fullName = _response.data!.fullName!;
      email = _response.data!.email!;
      phone = _response.data!.phone!;
      SupportUtils.showToast('update_profile_success'.tr,
          type: ToastType.SUCCESSFUL);

      editableEmail = email.isEmpty;
      update();
    } else {
      if (_response.getException == null) {
        if (_response.status == 404) {
          _response.setException(
              ApplicationError.withMessage('email_have_exists'.tr));
        }

        if (_response.getException == null) {
          _response.setException(ApplicationError.withCode(
              ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
        }
      }
      SupportUtils.showToast(_response.getException!.getErrorMessage(),
          type: ToastType.ERROR);
    }
    updatingInfo = false;
  }

  void updateAvatar(dynamic? photo) async {
  // void updateAvatar(AssetEntity? photo) async {
    updatingInfo = true;

    try {
      if (photo != null) {
        var _photoFile = (await photo.file)!;
        int _sizeInBytes = _photoFile.lengthSync();
        double _sizeInMb = _sizeInBytes / (1024 * 1024);
        int _photoQuality = 100;

        while (_sizeInMb > 3) {
          _photoQuality = (_photoQuality / 2).round();

          // final _drawFile = await photo.thumbnailDataWithOption(ThumbnailOption(
          //   size: ThumbnailSize(
          //     photo.size.width.round(),
          //     photo.size.height.round(),
          //   ),
          //   quality: _photoQuality,
          // ));
          final _tempDir = await getTemporaryDirectory();
          _photoFile =
              await File('${_tempDir.path}/tmp_${photo.title}.png').create();
          _photoFile.writeAsBytesSync(dynamic!);

          _sizeInBytes = _photoFile.lengthSync();
          _sizeInMb = _sizeInBytes / (1024 * 1024);
        }

        var response = await GolfApi().uploadAvartar(_photoFile);
        if (response?.data != null && (response?.data ?? '').isNotEmpty) {
          var _updateAvatar = await GolfApi().updateImagePath(response?.data);

          SupportUtils.prefs.setString(USER_AVATAR, _updateAvatar.imagesPaths!);
          imagePath = _updateAvatar.imagesPaths!;
          SupportUtils.showToast('success'.tr, type: ToastType.SUCCESSFUL);
          update();
        } else {
          _toastException(response?.getException);
        }
      }
    } catch (e) {
      _toastException(ApplicationError.withCode(
          ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
    }
    updatingInfo = false;
  }

  _toastException(ApplicationError? error) {
    if (error == null) {
      error = (ApplicationError.withCode(
          ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
    }
    SupportUtils.showToast(error.getErrorMessage(), type: ToastType.ERROR);
  }

  Future<bool> verifyAccount() async {
    _startTimerVerify();
    var languageCode = LocalizationService.locale;

    // Call Service Reset Password
    final _verifyResult =
        await GolfApi().verifyAccount(email, languageCode.languageCode);

    /// Handle Register result
    if (_verifyResult.data != null) {
      return true;
    } else {
      if (_verifyResult.getException == null) {
        _verifyResult.setException(ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
      }
      return false;
    }
  }

  // Future<String> getProfile() async {
  //   var response = await GolfApi().getUserInfo();
  //   if (response.data.userID != null) {
  //     isValidatedEmail = response.data.confirmEmail == 1 ? true : false;
  //   }
  //   return "";
  // }

  _startTimerVerify() {
    availableVerifyTimeLeft =
        ((SupportUtils.prefs.getInt(VERIFY_TIME_MILI) ?? 0) +
                300000 -
                DateTime.now().millisecondsSinceEpoch) ~/
            1000;
    isSentVerify = availableVerifyTimeLeft > 0;

    new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      availableVerifyTimeLeft--;
      if ((availableVerifyTimeLeft % 5) == 0) {
        getUserInfo(justupdateVerified: true);
      }
      if (availableVerifyTimeLeft < 0) {
        isSentVerify = false;
        timer.cancel();
      }
    });
  }

  Future<bool> removeUser() async {
    updatingInfo = true;
    bool isResult = false;
    int userID = SupportUtils.prefs.getInt(USER_ID) ?? 0;
    if (userID == 0) {
      updatingInfo = false;
    }
    var response = await GolfApi().removeUser(userID);
    if (response.data != null && response.data!) {
      isResult = true;
    }
    updatingInfo = false;
    return isResult;
  }
}
