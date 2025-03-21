import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/page_result.dart';
import 'package:golf_uiv2/screens/change_password/change_password_controller.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:golf_uiv2/widgets/button_default.dart';
import 'package:golf_uiv2/widgets/text_field.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:sizer/sizer.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _oldPasswordFocusNode = FocusNode();
    final _passwordFocusNode = FocusNode();
    final _confirmPasswordFocusNode = FocusNode();

    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: GolfColor.GolfPrimaryColor,
      appBar: ApplicationAppBar("back".tr),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6.0.w),
              topRight: Radius.circular(6.0.w)),
          color: themeData.scaffoldBackgroundColor,
        ),
        child: GetX<ChangePasswordController>(builder: (_controller) {
          return AbsorbPointer(
            absorbing: _controller.isChangePasswordProgressing,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    /// Change Password Form
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Old Password
                        TexFieldValidate(
                          _oldPasswordFocusNode,
                          // key: _passwordInputKey,
                          hintText: 'old_password'.tr,
                          icon: Icons.lock,
                          accentColor: GolfColor.GolfPrimaryColor,
                          themeData: themeData,
                          isPassword: true,
                          onChanged: (_value) {
                            _controller.oldPassword = _value ?? '';
                          },
                        ),
                        SizedBox(height: 20),

                        /// Password
                        TexFieldValidate(
                          _passwordFocusNode,
                          // key: _passwordInputKey,
                          hintText: 'new_password'.tr,
                          icon: Icons.lock,
                          accentColor: GolfColor.GolfPrimaryColor,
                          validate: _controller.validatePassword,
                          themeData: themeData,
                          isPassword: true,
                        ),
                        SizedBox(height: 20),

                        /// Confirm Password
                        TexFieldValidate(
                          _confirmPasswordFocusNode,
                          // key: _confirmPasswordInputKey,
                          hintText: 'confirm_new_password'.tr,
                          icon: Icons.lock,
                          accentColor: GolfColor.GolfPrimaryColor,
                          validate: _controller.validateConfirmPassword,
                          themeData: themeData,
                          isPassword: true,
                        ),
                        SizedBox(height: 35),

                        /// Change Password Button
                        Stack(children: [
                          Opacity(
                              opacity: _controller.isChangePasswordProgressing
                                  ? 1.0
                                  : 0.0,
                              child:
                                  Center(child: CircularProgressIndicator())),
                          Opacity(
                            opacity: _controller.isChangePasswordProgressing
                                ? 0.0
                                : 1.0,
                            child: DefaultButton(
                              text: 'change_password'.tr,
                              textColor: Colors.white,
                              backgroundColor: GolfColor.GolfPrimaryColor,
                              press: () async {
                                // Unfocus Textfield
                                _oldPasswordFocusNode.unfocus();
                                _passwordFocusNode.unfocus();
                                _confirmPasswordFocusNode.unfocus();

                                _controller.changePasswordErrorMessage =
                                    _controller.validatePassword(
                                            _controller.password) ??
                                        _controller.validateConfirmPassword(
                                            _controller.confirmPassword);
                                if (_controller.changePasswordErrorMessage ==
                                    null) {
                                  var _loginResult =
                                      await _controller.letsChangePassword();
                                  if (_loginResult) {
                                    Get.back(
                                        result: PageResult(
                                            resultCode: PageResultCode.OK));
                                  } else {
                                    SupportUtils.showToast(
                                        _controller.changePasswordErrorMessage,
                                        type: ToastType.ERROR);
                                  }
                                } else {
                                  SupportUtils.showToast(
                                      _controller.changePasswordErrorMessage,
                                      type: ToastType.ERROR);
                                }
                              },
                            ),
                          )
                        ]),
                        SizedBox(height: 40),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
