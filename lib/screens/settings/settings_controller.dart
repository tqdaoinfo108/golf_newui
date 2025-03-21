import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/model/user.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/translations/localization_service.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(() => SettingController());
  }
}

class SettingController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    userInfo = User(
      userID: SupportUtils.prefs.getInt(USER_ID),
      uUserID: SupportUtils.prefs.getString(USERNAME),
      fullName: SupportUtils.prefs.getString(USER_FULLNAME),
      email: SupportUtils.prefs.getString(USER_EMAIL),
      imagesPaths: SupportUtils.prefs.getString(USER_AVATAR),
      providerUserID: SupportUtils.prefs.getString(USER_PROVIDDER_ID),
      confirmEmail: SupportUtils.prefs.getInt(VERIFIED_EMAIL),
    );
  }

  final Rx<User?> _userInfo = User().obs;
  User? get userInfo => this._userInfo.value;
  set userInfo(User? value) => this._userInfo.value = value;

  final _totalVipMembers = 0.obs;
  int get totalVipMembers => _totalVipMembers.value;

  Future<bool> updateUserInfo() async {
    final _ueserInfoResult = await GolfApi().getUserInfo();

    /// Handle Register result
    if (_ueserInfoResult.data != null) {
      userInfo = _ueserInfoResult.data;

      /// Save User Information to SharePreference
      SupportUtils.prefs.setString(USERNAME, userInfo!.uUserID!);
      SupportUtils.prefs.setString(USER_FULLNAME, userInfo!.fullName!);
      SupportUtils.prefs.setString(USER_EMAIL, userInfo!.email!);
      SupportUtils.prefs.setInt(USER_ID, userInfo!.userID!);
      SupportUtils.prefs.setString(USER_PHONE, userInfo!.phone!);
      SupportUtils.prefs.setString(USER_AVATAR, userInfo!.imagesPaths!);
      SupportUtils.prefs.setInt(VERIFIED_EMAIL, userInfo!.confirmEmail!);
      return true;
    } else {
      if (_ueserInfoResult.getException == null) {
        _ueserInfoResult.setException(ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
      }
      return false;
    }
  }

  Future<bool> verifyAccount() async {
    var languageCode = LocalizationService.locale;

    // Call Service Reset Password
    final _verifyResult = await GolfApi()
        .verifyAccount(userInfo!.email, languageCode.languageCode);

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

  Future<void> getMyVipMember() async {
    var res = await new GolfApi().getUserVipMember(userInfo!.userID);

    if (res != null) {
      _totalVipMembers.value = res.data!.length;
    }
  }
}
