import 'package:flutter/material.dart';
import 'package:hl_image_picker_pro/hl_image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

import '../../model/decision_option.dart';
import '../../router/app_routers.dart';
import '../../utils/color.dart';
import '../../utils/constants.dart';
import '../../utils/keys.dart';
import '../../utils/support.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/application_appbar.dart';
import '../../widgets/avatar.dart';
import '../../widgets/button_default.dart';
import '../../widgets/default_avatar.dart';
import '../../widgets/pressable.dart';
import '../../widgets/text_field.dart';
import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  ProfileScreen({Key? key}) : super(key: key);
  final _usernameFocusNode = FocusNode();
  final _fullNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return GetX<ProfileController>(
      builder: (_controller) {
        return Scaffold(
          appBar: ApplicationAppBar(context, 'back'.tr),
          backgroundColor: GolfColor.GolfPrimaryColor,
          body: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(left: 2.0.h, right: 2.0.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.0.w),
                    topRight: Radius.circular(6.0.w),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Pressable(
                          splashColor: Colors.transparent,
                          pressRadius: 10,
                          padding: EdgeInsets.symmetric(vertical: 2.0.h),
                          onPress: () => _buildPicker(context),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              _controller.imagePath.isBlank!
                                  ? DefaultAvatar()
                                  : Avatar(
                                    avatarPath:
                                        '$GOLF_CORE_API_URL$USER_AVATAR_PATH${_controller.imagePath}',
                                  ),
                              Icon(
                                Icons.camera_enhance,
                                color: Colors.white,
                                size: 6.0.w,
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// Username
                      TexFieldValidate(
                        _usernameFocusNode,
                        enable: false,
                        initialValue: _controller.username,
                        hintText: 'username'.tr,
                        icon: Icons.person,
                        accentColor: GolfColor.GolfPrimaryColor,
                        validate: _controller.validateUsername,
                        themeData: themeData,
                      ),
                      SizedBox(height: 2.0.h),

                      /// Full Name
                      TexFieldValidate(
                        _fullNameFocusNode,
                        initialValue: _controller.fullName,
                        hintText: 'full_name'.tr,
                        icon: AppIcon.user,
                        accentColor: GolfColor.GolfPrimaryColor,
                        validate: _controller.validateFullName,
                        themeData: themeData,
                      ),
                      SizedBox(height: 2.0.h),

                      /// Email
                      TexFieldValidate(
                        _emailFocusNode,
                        initialValue: _controller.email,
                        enable: _controller.editableEmail,
                        hintText: 'email'.tr,
                        icon: Icons.mail,
                        accentColor: GolfColor.GolfPrimaryColor,
                        validate: _controller.validateEmail,
                        themeData: themeData,
                      ),
                      SizedBox(height: 2.0.h),

                      // phone
                      TexFieldValidate(
                        _emailFocusNode,
                        initialValue: _controller.phone,
                        enable: true,
                        hintText: 'phone'.tr,
                        icon: Icons.phone,
                        accentColor: GolfColor.GolfPrimaryColor,
                        validate: _controller.validatePhone,
                        themeData: themeData,
                        textInputType: TextInputType.phone,
                      ),
                      SizedBox(height: 2.0.h),

                      // Visibility(
                      //     visible: !_controller.isVerifiedAccount,
                      //     child: AbsorbPointer(
                      //       absorbing: _controller.isSentVerify,
                      //       child: Opacity(
                      //         opacity: !_controller.isSentVerify ? 1.0 : 0.2,
                      //         child: DefaultButton(
                      //           text: 'verify_email'.tr +
                      //               (_controller.availableVerifyTimeLeft > 0
                      //                   ? ' (${controller.availableVerifyTimeLeft})'
                      //                   : ''),
                      //           textColor: Colors.white,
                      //           backgroundColor: Colors.orange,
                      //           press: () async {
                      //             // Unfocus Textfield
                      //             _fullNameFocusNode.unfocus();
                      //             _emailFocusNode.unfocus();
                      //             _passwordFocusNode.unfocus();
                      //             _confirmPasswordFocusNode.unfocus();

                      //             verifyEmailAccount();
                      //           },
                      //         ),
                      //       ),
                      //     )),
                      // SizedBox(height: 2.0.h),
                      Visibility(
                        visible: controller.isRemoveUser,
                        child: DefaultButton(
                          text: 'delete_account'.tr,
                          textColor: Colors.white,
                          backgroundColor: Colors.red,
                          press: () async {
                            SupportUtils.showDecisionDialog(
                              "delete_account_confirmation_title".tr,
                              decisionDescription: 
                                  "delete_account_confirmation".tr,
                              lstOptions: [
                                DecisionOption(
                                  'yes'.tr,
                                  onDecisionPressed: () async {
                                    _fullNameFocusNode.unfocus();
                                    _emailFocusNode.unfocus();
                                    _passwordFocusNode.unfocus();
                                    _confirmPasswordFocusNode.unfocus();

                                    var isResult =
                                        await controller.removeUser();
                                    if (isResult) {
                                      SupportUtils.letsLogout();
                                      SupportUtils.showToast(
                                        "delete_account_successful".tr,
                                        type: ToastType.SUCCESSFUL,
                                      );
                                      Get.offAllNamed(AppRoutes.LOGIN);
                                    }
                                  },
                                ),
                                DecisionOption(
                                  'no'.tr,
                                  isImportant: true,
                                  type: DecisionOptionType.DENIED,
                                  onDecisionPressed: null,
                                ),
                              ],
                            );
                            // Unfocus Textfield
                          },
                        ),
                      ),
                      if (controller.isRemoveUser) SizedBox(height: 2.0.h),

                      DefaultButton(
                        text: 'save'.tr,
                        textColor: Colors.white,
                        backgroundColor: Color(0xff08D586),
                        press: () async {
                          // Unfocus Textfield
                          _fullNameFocusNode.unfocus();
                          _emailFocusNode.unfocus();
                          _passwordFocusNode.unfocus();
                          _confirmPasswordFocusNode.unfocus();

                          _controller.signUpErrorMessage = null;
                          if (_controller.isValidatedFullname &&
                              _controller.isValidatedEmail &&
                              _controller.isValidatedPhone) {
                            _controller.updateProfile();
                          } else {
                            SupportUtils.showToast(
                              _controller.validateFullName(
                                    _controller.fullName,
                                  ) ??
                                  _controller.validateEmail(
                                    _controller.email,
                                  ) ??
                                  _controller.validatePhone(_controller.phone),
                              type: ToastType.ERROR,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () =>
                    controller.updatingInfo
                        ? _buildLoadingIndicator(themeData)
                        : Container(),
              ),
            ],
          ),
        );
      },
    );
  }

  verifyEmailAccount() {
    if ((SupportUtils.prefs.getString(USER_EMAIL) ?? "").isEmpty) {
      SupportUtils.showToast('email_empty'.tr, type: ToastType.ERROR);
    } else if ((DateTime.now().millisecondsSinceEpoch -
            (SupportUtils.prefs.getInt(VERIFY_TIME_MILI) ?? 0)) <
        300000) {
      SupportUtils.showToast('sent_verify_email'.tr);
    } else {
      SupportUtils.showToast('sent_verify_email'.tr);
      SupportUtils.prefs.setInt(
        VERIFY_TIME_MILI,
        DateTime.now().millisecondsSinceEpoch,
      );
      Get.find<ProfileController>().verifyAccount();
    }
  }

  _buildLoadingIndicator(ThemeData appTheme) => Pressable(
    backgroundColor: appTheme.colorScheme.background.withOpacity(.4),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(6.0.w),
      topRight: Radius.circular(6.0.w),
    ),
    child: Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );

  _buildPicker(BuildContext context) async {
    final _picker = HLImagePicker();

    final images = await _picker.openPicker(
      pickerOptions: HLPickerOptions(maxSelectedAssets: 1),
    );

    if (images.isEmpty) {
      return;
    }

    controller.updateAvatar(images.first.path);
  }
}
