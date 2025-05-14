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

import '../../model/group_model.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _emailFocusNode = FocusNode();

    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: GolfColor.GolfPrimaryColor,
      appBar: ApplicationAppBar(context, "login".tr),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6.0.w),
                  topRight: Radius.circular(6.0.w),
                ),
                color: themeData.scaffoldBackgroundColor,
              ),
              child: GetX<ForgotPasswordController>(
                builder: (_controller) {
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
                            Stack(
                              children: [
                                Opacity(
                                  opacity:
                                      _controller.isForgotPasswordProgressing
                                          ? 1.0
                                          : 0.0,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                Opacity(
                                  opacity:
                                      _controller.isForgotPasswordProgressing
                                          ? 0.0
                                          : 1.0,
                                  child: DefaultButton(
                                    text: 'reset_password'.tr,
                                    textColor: Colors.white,
                                    backgroundColor: GolfColor.GolfPrimaryColor,
                                    press: () async {
                                      // Unfocus Textfield
                                      _emailFocusNode.unfocus();

                                      _controller.forgotPasswordErrorMessage =
                                          null;
                                      if (_controller.isValidatedEmail) {
                                        await _controller.getListGroupByEmail();
                                        if (controller.groupList.isEmpty) {
                                          SupportUtils.showToast(
                                            'not_fount_data'.tr,
                                            type: ToastType.ERROR,
                                          );
                                          return;
                                        }
                                        showDialog<String>(
                                          context: context,
                                          builder:
                                              (BuildContext context) => Obx(
                                                () => Dialog(
                                                  backgroundColor:
                                                      GolfColor
                                                          .BackgroundCardLightColor,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      SizedBox(height: 20),
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                              maxHeight: 300,
                                                            ),
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              for (var item
                                                                  in controller
                                                                      .groupList
                                                                      .value)
                                                                ListTile(
                                                                  title: Text(
                                                                    item.nameGroupShop ??
                                                                        "",
                                                                    style:
                                                                        Theme.of(
                                                                          context,
                                                                        ).textTheme.bodyMedium,
                                                                  ),
                                                                  leading: Radio<
                                                                    int
                                                                  >(
                                                                    value:
                                                                        item.groupShopID!,
                                                                    groupValue:
                                                                        controller
                                                                            .valueGroupChoose
                                                                            .value,
                                                                    onChanged: (
                                                                      value,
                                                                    ) {
                                                                      controller
                                                                          .valueGroupChoose
                                                                          .value = value!;
                                                                    },
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Text(
                                                              'cancel'.tr,
                                                              style:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .textTheme
                                                                      .titleMedium,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          TextButton(
                                                            onPressed: () async {
                                                              if (controller
                                                                      .valueGroupChoose
                                                                      .value ==
                                                                  0) {
                                                                SupportUtils.showToast(
                                                                  'application_error'
                                                                      .tr,
                                                                  type:
                                                                      ToastType
                                                                          .ERROR,
                                                                );
                                                                return;
                                                              }
                                                              Get.back();

                                                              var _loginResult =
                                                                  await _controller
                                                                      .letsResetPassword();
                                                              if (_loginResult) {
                                                                Get.back(
                                                                  result: PageResult(
                                                                    resultCode:
                                                                        PageResultCode
                                                                            .OK,
                                                                  ),
                                                                );
                                                              } else {
                                                                SupportUtils.showToast(
                                                                  _controller
                                                                      .forgotPasswordErrorMessage,
                                                                  type:
                                                                      ToastType
                                                                          .ERROR,
                                                                );
                                                              }
                                                            },
                                                            child: Text(
                                                              'save'.tr,
                                                              style:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .textTheme
                                                                      .titleMedium,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        );
                                        // if (_loginResult) {
                                        //   Get.back(
                                        //     result: PageResult(
                                        //       resultCode: PageResultCode.OK,
                                        //     ),
                                        //   );
                                        // } else {
                                        //   SupportUtils.showToast(
                                        //     _controller
                                        //         .forgotPasswordErrorMessage,
                                        //     type: ToastType.ERROR,
                                        //   );
                                        // }
                                      } else {
                                        SupportUtils.showToast(
                                          _controller.validateEmail(
                                            _controller.email,
                                          ),
                                          type: ToastType.ERROR,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
