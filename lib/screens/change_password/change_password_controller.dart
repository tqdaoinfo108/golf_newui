import 'package:get/get.dart';
import 'package:golf_uiv2/model/base_respose.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/constants.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
  }
}

class ChangePasswordController extends GetxController {
  var isValidatedPassword = false;
  var isValidatedConfirmPassword = false;

  final _isChangePasswordProgressing = false.obs;
  bool get isChangePasswordProgressing =>
      this._isChangePasswordProgressing.value;
  set isChangePasswordProgressing(bool value) =>
      this._isChangePasswordProgressing.value = value;

  final _oldPassword = ''.obs;
  String get oldPassword => this._oldPassword.value;
  set oldPassword(String value) => this._oldPassword.value = value;

  final _password = ''.obs;
  String get password => this._password.value;
  set password(String value) => this._password.value = value;

  final _confirmPassword = ''.obs;
  String get confirmPassword => this._confirmPassword.value;
  set confirmPassword(String value) => this._confirmPassword.value = value;

  final _changePasswordErrorMessage = Rx<String?>(null);
  String? get changePasswordErrorMessage =>
      this._changePasswordErrorMessage.value;
  set changePasswordErrorMessage(String? value) =>
      this._changePasswordErrorMessage.value = value;

  // String validateOldPassword(String value) {
  //   // update value
  //   oldPassword = value?.trim() ?? '';

  //   // validate value
  //   if (oldPassword.isEmpty) {
  //     isValidatedOldPassword = true;
  //     return null;
  //   }
  //   if (oldPassword.isEmpty) {
  //     isValidatedOldPassword = false;
  //     return 'old_password_not_alow_empty'.tr;
  //   }
  //   isValidatedOldPassword = true;
  //   return null;
  // }

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

  Future<bool> letsChangePassword() async {
    var _changePasswordResult = BaseResponse<bool>();
    changePasswordErrorMessage = null;
    isChangePasswordProgressing = true;

    /// Call Service Register
    _changePasswordResult =
        await GolfApi().changePassword(oldPassword, password);

    isChangePasswordProgressing = false;

    /// Handle Change Password result
    if (_changePasswordResult.data != null) {
      if (_changePasswordResult.data!)
        return true;
      else {
        changePasswordErrorMessage = 'old_password_incorrect'.tr;
        return false;
      }
    } else {
      if (_changePasswordResult.getException == null) {
        _changePasswordResult.setException(ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
      }
      changePasswordErrorMessage =
          _changePasswordResult.getException?.getErrorMessage();
      return false;
    }
  }
}
