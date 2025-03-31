import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/page_result.dart';
import 'package:golf_uiv2/screens/forgot_password/forgot_password_controller.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:golf_uiv2/widgets/button_default.dart';
import 'package:golf_uiv2/widgets/text_field.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _emailFocusNode = FocusNode();

    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: GolfColor.GolfPrimaryColor,
      appBar: ApplicationAppBar(context,"login".tr),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.0.w),
                    topRight: Radius.circular(6.0.w)),
                color: themeData.scaffoldBackgroundColor,
              ),
              child: GetX<ForgotPasswordController>(builder: (_controller) {
                return AbsorbPointer(
                  absorbing: _controller.isForgotPasswordProgressing,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Email
                          TexFieldValidate(
                            _emailFocusNode,
                            initialValue: _controller.email,
                            hintText: 'email'.tr,
                            icon: Icons.mail,
                            accentColor: GolfColor.GolfPrimaryColor,
                            validate: _controller.validateEmail,
                            themeData: themeData,
                          ),
                          SizedBox(height: 20),

                          /// Reset password Button
                          Stack(children: [
                            Opacity(
                                opacity: _controller.isForgotPasswordProgressing
                                    ? 1.0
                                    : 0.0,
                                child:
                                    Center(child: CircularProgressIndicator())),
                            Opacity(
                              opacity: _controller.isForgotPasswordProgressing
                                  ? 0.0
                                  : 1.0,
                              child: DefaultButton(
                                text: 'reset_password'.tr,
                                textColor: Colors.white,
                                backgroundColor: GolfColor.GolfPrimaryColor,
                                press: () async {
                                  // Unfocus Textfield
                                  _emailFocusNode.unfocus();

                                  _controller.forgotPasswordErrorMessage = null;
                                  if (_controller.isValidatedEmail) {
                                    var _loginResult =
                                        await _controller.letsResetPassword();
                                    if (_loginResult) {
                                      Get.back(
                                          result: PageResult(
                                              resultCode: PageResultCode.OK));
                                    } else {
                                      SupportUtils.showToast(
                                          _controller
                                              .forgotPasswordErrorMessage,
                                          type: ToastType.ERROR);
                                    }
                                  } else {
                                    SupportUtils.showToast(
                                        _controller
                                            .validateEmail(_controller.email),
                                        type: ToastType.ERROR);
                                  }
                                },
                              ),
                            )
                          ]),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
