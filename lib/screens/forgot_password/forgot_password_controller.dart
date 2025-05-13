import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/translations/localization_service.dart';
import 'package:golf_uiv2/utils/constants.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
  }
}

class ForgotPasswordController extends GetxController {
  var isValidatedEmail = false;

  final _isForgotPasswordProgressing = false.obs;
  bool get isForgotPasswordProgressing =>
      this._isForgotPasswordProgressing.value;
  set isForgotPasswordProgressing(bool value) =>
      this._isForgotPasswordProgressing.value = value;

  final _email = ''.obs;
  String get email => this._email.value;
  set email(String value) => this._email.value = value;

  final _forgotPasswordErrorMessage = Rx<String?>(null);
  String? get forgotPasswordErrorMessage =>
      this._forgotPasswordErrorMessage.value;
  set forgotPasswordErrorMessage(String? value) =>
      this._forgotPasswordErrorMessage.value = value;

  String? validateEmail(String? value) {
    // update value
    email = value?.trim() ?? '';

    // validate value
    if (email.isEmpty) {
      isValidatedEmail = false;
      return 'email_not_alow_empty'.tr;
    }
    var _isValidEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
    if (!_isValidEmail) {
      isValidatedEmail = false;
      return 'email_invalid'.tr;
    }
    isValidatedEmail = true;
    return null;
  }

  Future<bool> getListGroupByEmail() async {
    isForgotPasswordProgressing = true;
    final _resetPasswordResult = await GolfApi().getGroupUserByEmail(email);
    await Future.delayed(Duration(seconds: 5));
    return true;
  }

  Future<bool> letsResetPassword() async {
    var languageCode = LocalizationService.locale;

    forgotPasswordErrorMessage = null;
    isForgotPasswordProgressing = true;

    // Call Service Reset Password
    final _resetPasswordResult = await GolfApi().resetPassword(
      email,
      languageCode.languageCode.toLowerCase(),
    );
    isForgotPasswordProgressing = false;

    /// Handle Register result
    if (_resetPasswordResult.data != null) {
      return true;
    } else {
      if (_resetPasswordResult.getException == null) {
        if (_resetPasswordResult.status == 406) {
          _resetPasswordResult.setException(
            ApplicationError.withMessage('password_change_failed'.tr),
          );
        }
        if (_resetPasswordResult.status == 408) {
          _resetPasswordResult.setException(
            ApplicationError.withMessage('account_has_been_blocked'.tr),
          );
        }
        if (_resetPasswordResult.status == 407) {
          _resetPasswordResult.setException(
            ApplicationError.withMessage(
              "${'unverified_account'.tr}. ${'password_change_failed'.tr}",
            ),
          );
        }
        if (_resetPasswordResult.status == 409) {
          _resetPasswordResult.setException(
            ApplicationError.withMessage('email_not_exist_in_system'.tr),
          );
        }

        if (_resetPasswordResult.getException == null) {
          _resetPasswordResult.setException(
            ApplicationError.withCode(
              ApplicationErrorCode.UNKNOW_APPLICATION_ERROR,
            ),
          );
        }
      }
      forgotPasswordErrorMessage =
          _resetPasswordResult.getException?.getErrorMessage();
      return false;
    }
  }
}
