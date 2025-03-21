import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/widgets/app_icon.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:golf_uiv2/widgets/button_default.dart';
import 'package:golf_uiv2/widgets/text_field.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:sizer/sizer.dart';

import 'sign_up_controller.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _usernameFocusNode = FocusNode();
    final _fullNameFocusNode = FocusNode();
    final _emailFocusNode = FocusNode();
    final _passwordFocusNode = FocusNode();
    final _confirmPasswordFocusNode = FocusNode();

    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: GolfColor.GolfPrimaryColor,
      appBar: ApplicationAppBar("login".tr),
      body: Container(
          child: Column(
        children: [
          /// Register Form
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6.0.w),
                  topRight: Radius.circular(6.0.w)),
              color: themeData.scaffoldBackgroundColor,
            ),
            child: GetX<SignUpController>(builder: (_controller) {
              return AbsorbPointer(
                absorbing: _controller.isSignUpProgressing,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        /// Sign Up Form
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Username
                            TexFieldValidate(
                              _usernameFocusNode,
                              // key: _usernameInputKey,
                              controller: _controller.userNameController,
                              // initialValue: _controller.username,
                              hintText: 'username'.tr,
                              icon: AppIcon.indentity_user,
                              accentColor: GolfColor.GolfPrimaryColor,
                              validate: _controller.validateUsername,
                              themeData: themeData,
                              enable: false,
                            ),
                            SizedBox(height: 20),

                            /// Full Name
                            TexFieldValidate(
                              _fullNameFocusNode,
                              // key: _fullNameInputKey,
                              initialValue: _controller.fullName,
                              hintText: 'full_name'.tr,
                              icon: AppIcon.user,
                              accentColor: GolfColor.GolfPrimaryColor,
                              validate: _controller.validateFullName,
                              themeData: themeData,
                            ),
                            SizedBox(height: 20),

                            /// Email
                            TexFieldValidate(
                              _emailFocusNode,
                              initialValue: _controller.email,
                              // key: _emailInputKey,
                              hintText: 'email'.tr,
                              icon: Icons.mail,
                              accentColor: GolfColor.GolfPrimaryColor,
                              validate: _controller.validateEmail,
                              themeData: themeData,
                            ),
                            SizedBox(height: 20),

                            /// Password
                            TexFieldValidate(
                              _passwordFocusNode,
                              // key: _passwordInputKey,
                              hintText: 'password'.tr,
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
                              hintText: 'confirm_password'.tr,
                              icon: Icons.lock,
                              accentColor: GolfColor.GolfPrimaryColor,
                              validate: _controller.validateConfirmPassword,
                              themeData: themeData,
                              isPassword: true,
                            ),
                            SizedBox(height: 35),

                            /// Sign up Button
                            Stack(children: [
                              Opacity(
                                  opacity: _controller.isSignUpProgressing
                                      ? 1.0
                                      : 0.0,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                              Opacity(
                                opacity:
                                    _controller.isSignUpProgressing ? 0.0 : 1.0,
                                child: DefaultButton(
                                  text: 'sign_up'.tr,
                                  textColor: Colors.white,
                                  backgroundColor: GolfColor.GolfPrimaryColor,
                                  press: () async {
                                    // Unfocus Textfield
                                    _fullNameFocusNode.unfocus();
                                    _emailFocusNode.unfocus();
                                    _passwordFocusNode.unfocus();
                                    _confirmPasswordFocusNode.unfocus();

                                    _controller.signUpErrorMessage = _controller
                                            .validateUsername(
                                                _controller.username) ??
                                        _controller.validateFullName(
                                            _controller.fullName) ??
                                        _controller
                                            .validateEmail(_controller.email) ??
                                        _controller.validatePassword(
                                            _controller.password) ??
                                        _controller.validateConfirmPassword(
                                            _controller.confirmPassword);
                                    if (_controller.signUpErrorMessage ==
                                        null) {
                                      var _loginResult =
                                          await _controller.letsSignUp();
                                      if (_loginResult) {
                                        Get.offAllNamed(AppRoutes.HOME);
                                      } else {
                                        SupportUtils.showToast(
                                            _controller.signUpErrorMessage,
                                            type: ToastType.ERROR);
                                        // _formKey.currentState.validate();
                                      }
                                    } else {
                                      SupportUtils.showToast(
                                          _controller.signUpErrorMessage,
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
          )),
        ],
      )),
    );
  }
}
