import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/page_result.dart';
import 'package:golf_uiv2/model/user.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/app_icon.dart';
import 'package:golf_uiv2/widgets/app_loading_indicator.dart';
import 'package:golf_uiv2/widgets/button_default.dart';
import 'package:golf_uiv2/widgets/text_field.dart';
import 'package:golf_uiv2/widgets/widget_custom.dart';
import 'login_controller.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _usernameFocusNode = FocusNode();
    final _passwordFocusNode = FocusNode();

    ThemeData themeData = Theme.of(context);
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ConstrainedBox(
              constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                 Column(
                  children: [
                     SvgPicture.asset("assets/svg/new_login_top_bg.svg", width: 100.w),
                  Center(
                    child: Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: SizerUtil.width / 2.2,
                      ),
                    ),
                  ),
              
                  /// Login Form
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Obx(
                      () => AbsorbPointer(
                        absorbing: controller.isLoginProgressing,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return IntrinsicHeight(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 4.0.w),
              
                                      /// Username
                                      TexFieldValidate(
                                        _usernameFocusNode,
                                        hintText: 'username'.tr,
                                        icon: AppIcon.indentity_user,
                                        accentColor: GolfColor.GolfPrimaryColor,
                                        validate: controller.validateUsername,
                                        themeData: themeData,
                                      ),
                                      SizedBox(height: 2.0.w),
              
                                      /// Password
                                      TexFieldValidate(
                                        _passwordFocusNode,
                                        hintText: 'password'.tr,
                                        icon: Icons.lock,
                                        accentColor: GolfColor.GolfPrimaryColor,
                                        validate: controller.validatePassword,
                                        themeData: themeData,
                                        isPassword: true,
                                      ),
                                      SizedBox(height: 3.0.w),
              
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextClick(
                                          themeData: themeData,
                                          lastText: 'forgot_password'.tr,
                                          onClicked: () async {
                                            var _resetPasswordResult =
                                                await Get.toNamed(
                                                  AppRoutes.FORGOT_PASSWORD,
                                                );
                                            if (_resetPasswordResult != null &&
                                                (_resetPasswordResult as PageResult)
                                                        .resultCode ==
                                                    PageResultCode.OK) {
                                              SupportUtils.showToast(
                                                'reset_password_sueccessful'.tr,
                                                type: ToastType.SUCCESSFUL,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 8.0.w),
                                      controller.isLoginProgressing
                                          ? AppLoadingIndicator()
                                          : DefaultButton(
                                            text: 'login'.tr,
                                            textColor: Colors.white,
                                            backgroundColor: GolfColor.GolfSubColor,
                                            press:
                                                () => _loginPressed(
                                                  _usernameFocusNode,
                                                  _passwordFocusNode,
                                                ),
                                          ),
                                      SizedBox(height: 2.0.w),
                                      // Text(
                                      //   'dont_have_account'.tr,
                                      //   style: themeData.textTheme.headlineSmall,
                                      //   maxLines: 2,
                                      // ),
                                      // SizedBox(height: 2.0.w),
                                      if (controller.isHideSocial.value)
                                        TextClick(
                                          themeData: themeData,
                                          lastText: 'sign_up_now'.tr,
                                          onClicked: () async {
                                            Get.toNamed(AppRoutes.SIGN_UP);
                                          },
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  ],
                 ),
                  // Footer
                  if (controller.isHideSocial.value)
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 15,
                            children: [
                              SizedBox(
                                width: 15.w,
                                child: Divider(
                                  color: GolfColor.GolfSubColor,
                                  thickness: 2,
                                ),
                              ),
                              Text(
                                'or_login_with'.tr.toLowerCase(),
                                style: themeData.textTheme.headlineSmall,
                              ),
                              SizedBox(
                                width: 15.w,
                                child: Divider(
                                  color: GolfColor.GolfSubColor,
                                  thickness: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.0.w),
                          _loginSocialButton(
                            themeData,
                            onLoginGooglePressed:
                                () => loginWithSocialNetwork(
                                  SocialNetwork.GOOGLE,
                                  themeData,
                                ),
                            onLoginFacebookPressed:
                                () => loginWithSocialNetwork(
                                  SocialNetwork.FACEBOOK,
                                  themeData,
                                ),
                            onLoginLinePressed:
                                () => loginWithSocialNetwork(
                                  SocialNetwork.LINE,
                                  themeData,
                                ),
                            onLoginZaloPressed:
                                () => loginWithSocialNetwork(
                                  SocialNetwork.ZALO,
                                  themeData,
                                ),
                            hasAppleLoginButton: controller.isAppleIdLoginAvailable,
                            onLoginApplePressed:
                                () => loginWithSocialNetwork(
                                  SocialNetwork.APPLE,
                                  themeData,
                                ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _loginSocialButton(
    ThemeData themeData, {
    required void Function() onLoginGooglePressed,
    required void Function() onLoginFacebookPressed,
    required void Function() onLoginLinePressed,
    required void Function() onLoginZaloPressed,
    void Function()? onLoginApplePressed,
    bool hasAppleLoginButton = false,
  }) => Row(
    spacing: 30,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      InkWell(
        onTap: () => onLoginGooglePressed.call(),
        child: Image.asset("assets/icons/google.png", height: 5.0.h),
      ),
      // SizedBox(width: 2.0.w),
      // InkWell(
      //   onTap: () => onLoginFacebookPressed.call(),
      //   child: Image.asset("assets/icons/facebook.png", height: 5.0.h),
      // ),
      // SizedBox(width: 2.0.w),
      if (hasAppleLoginButton) ...[
        InkWell(
          onTap: () => onLoginApplePressed?.call(),
          child: Image.asset("assets/icons/apple.png", height: 5.0.h),
        ),
      ],
      // SizedBox(width: 2.0.w),
      InkWell(
        onTap: () => onLoginLinePressed.call(),
        child: Image.asset("assets/icons/line.png", height: 5.0.h),
      ),
      // SizedBox(width: 2.0.w),
      // Image.asset("assets/icons/zalo.png", height: 5.0.h)
      //     .onTap(onLoginZaloPressed),
    ],
  );

  _loginPressed(
    FocusNode _usernameFocusNode,
    FocusNode _passwordFocusNode,
  ) async {
    _usernameFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    controller.loginErrorMessage = null;

    if (controller.isValidatedUserName && controller.isValidatedPasssword) {
      var _loginResult = await controller.letsLogin();
      if (_loginResult) {
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        SupportUtils.showToast(
          controller.loginErrorMessage,
          type: ToastType.ERROR,
        );
      }
    } else {
      SupportUtils.showToast(
        controller.validateUsername(controller.userName) ??
            controller.validatePassword(controller.userPassword),
        type: ToastType.ERROR,
      );
    }
  }

  loginWithSocialNetwork(
    SocialNetwork socialNetwork,
    ThemeData themeData,
  ) async {
    User? _userTmp = User();

    switch (socialNetwork) {
      /// Login with Facebook Account
      case SocialNetwork.FACEBOOK:
        var _loginFacebookResult =
            await Get.find<LoginController>().loginFacebook();

        _userTmp = _loginFacebookResult;
        break;

      /// Login with Goolge Account
      case SocialNetwork.GOOGLE:
        var _loginGoogleResult =
            await Get.find<LoginController>().loginGoogle();

        _userTmp = _loginGoogleResult;
        break;

      /// Login with Line Account
      case SocialNetwork.LINE:
        var _loginLineResult = await Get.find<LoginController>().loginLine();

        _userTmp = _loginLineResult;
        break;

      /// Login with Zalo Account
      case SocialNetwork.ZALO:
        var _loginZaloResult = await Get.find<LoginController>().loginZalo();

        _userTmp = _loginZaloResult;
        break;

      /// Login with Zalo Account
      case SocialNetwork.APPLE:
        var _loginAppleResult =
            await Get.find<LoginController>().loginAppleID();

        _userTmp = _loginAppleResult;
        break;
    }

    if (_userTmp != null) {
      _userTmp.provider = socialNetwork.toString().split('.')[1];

      /// Lets login
      var _loginResult = await Get.find<LoginController>()
          .letsLoginBySocialNetwork(_userTmp);

      if (_loginResult) {
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        SupportUtils.showToast(
          Get.find<LoginController>().loginErrorMessage,
          themeData: themeData,
          type: ToastType.ERROR,
        );

        SupportUtils.logoutFacebook();
        SupportUtils.logoutGoogle();
        SupportUtils.logoutLine();
        SupportUtils.logoutZalo();
      }
    } else {
      SupportUtils.showToast(
        Get.find<LoginController>().loginErrorMessage,
        themeData: themeData,
        type: ToastType.ERROR,
      );
    }
  }
}
