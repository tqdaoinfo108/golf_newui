import 'package:flutter/material.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/app_icon.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:golf_uiv2/widgets/avatar.dart';
import 'package:golf_uiv2/widgets/button_default.dart';
import 'package:golf_uiv2/widgets/default_avatar.dart';
import 'package:golf_uiv2/widgets/pressable.dart';
import 'package:golf_uiv2/widgets/text_field.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

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

    return GetX<ProfileController>(builder: (_controller) {
      return Scaffold(
        appBar: ApplicationAppBar('back'.tr),
        backgroundColor: GolfColor.GolfPrimaryColor,
        body: Stack(children: [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(left: 2.0.h, right: 2.0.h, top: 2.0.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6.0.w),
                  topRight: Radius.circular(6.0.w)),
              color: Theme.of(context).scaffoldBackgroundColor,
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
                          )
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
                    icon: AppIcon.indentity_user,
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

                  Visibility(
                      visible: !_controller.isVerifiedAccount,
                      child: AbsorbPointer(
                        absorbing: _controller.isSentVerify,
                        child: Opacity(
                          opacity: !_controller.isSentVerify ? 1.0 : 0.2,
                          child: DefaultButton(
                            text: 'verify_email'.tr +
                                (_controller.availableVerifyTimeLeft > 0
                                    ? ' (${controller.availableVerifyTimeLeft})'
                                    : ''),
                            textColor: Colors.white,
                            backgroundColor: Colors.orange,
                            press: () async {
                              // Unfocus Textfield
                              _fullNameFocusNode.unfocus();
                              _emailFocusNode.unfocus();
                              _passwordFocusNode.unfocus();
                              _confirmPasswordFocusNode.unfocus();

                              verifyEmailAccount();
                            },
                          ),
                        ),
                      )),
                  SizedBox(height: 2.0.h),

                  Visibility(
                      visible: controller.isRemoveUser,
                      child: DefaultButton(
                        text: 'delete_account'.tr,
                        textColor: Colors.white,
                        backgroundColor: Colors.red,
                        press: () async {
                          // Unfocus Textfield
                          _fullNameFocusNode.unfocus();
                          _emailFocusNode.unfocus();
                          _passwordFocusNode.unfocus();
                          _confirmPasswordFocusNode.unfocus();

                          var isResult = await controller.removeUser();
                          if (isResult) {
                            SupportUtils.letsLogout();
                            SupportUtils.showToast(
                              "success".tr,
                              type: ToastType.SUCCESSFUL,
                            );
                            Get.offAllNamed(AppRoutes.LOGIN);
                          }
                        },
                      )),
                  if (controller.isRemoveUser) SizedBox(height: 2.0.h),

                  DefaultButton(
                    text: 'save'.tr,
                    textColor: Colors.white,
                    backgroundColor: GolfColor.GolfPrimaryColor,
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
                            _controller
                                    .validateFullName(_controller.fullName) ??
                                _controller.validateEmail(_controller.email) ??
                                _controller.validatePhone(_controller.phone),
                            type: ToastType.ERROR);
                      }
                    },
                  ),

                ],
              ),
            ),
          ),
          Obx(() => controller.updatingInfo
              ? _buildLoadingIndicator(themeData)
              : Container()),
        ]),
      );
    });
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
      SupportUtils.prefs
          .setInt(VERIFY_TIME_MILI, DateTime.now().millisecondsSinceEpoch);
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

  _buildPicker(BuildContext context) {
    // _checkPermission().then((granted) {
    //   if (!granted) {
    //     SupportUtils.showToast(
    //         'app_not_have_permission_to_access_the_photos'.tr,
    //         type: ToastType.ERROR);
    //     return;
    //   }

      // To build your own custom picker use this api
    //   PhotoManager.getAssetPathList(type: RequestType.image)
    //     ..then(
    //       (albums) => Get.toNamed(
    //         AppRoutes.PICK_IMAGE_ALBUM_LIST,
    //         arguments: (albums.where((album) => album.assetCount > 0).toList()),
    //       )?.then((result) {
    //         if (result?.resultCode == PageResultCode.OK)
    //           controller.updateAvatar(result?.data);
    //       }),
    //     )
    //     ..catchError((e) {
    //       SupportUtils.showToast('Get albums fail: $e');
    //     });
    // });
  }
  //
  // Future<bool> _checkPermission() async {
  //   final PermissionState res = await PhotoManager.requestPermissionExtend();
  //   return res == PermissionState.authorized || res == PermissionState.limited;
  // }
}
