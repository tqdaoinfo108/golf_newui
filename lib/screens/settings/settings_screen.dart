import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/page_result.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/screens/about_app/about_app.dart';
import 'package:golf_uiv2/screens/change_language/change_language_scree.dart';
import 'package:golf_uiv2/screens/change_theme_mode/change_theme_mode_screen.dart';
import 'package:golf_uiv2/screens/settings/settings_controller.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/widgets/avatar.dart';
import 'package:golf_uiv2/widgets/default_avatar.dart';
import 'package:golf_uiv2/widgets/pressable.dart';
import 'package:sizer/sizer.dart';
import 'package:golf_uiv2/widgets/settings_item.dart';
import 'package:golf_uiv2/utils/support.dart';

class SettingsScreen extends GetView<SettingController> {
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return GetBuilder<SettingController>(
      initState: (_) {
        controller.updateUserInfo().then((value) {
          if (value) {
            if (controller.userInfo!.confirmEmail ==
                ConfirmEmailStatus.UNCONFIRMED) {
              SupportUtils.showToast(
                'account_is_unconfirmed'.tr,
                type: ToastType.WARNING,
                durationMili: 5000,
              );
            }
          }
        });
        controller.getMyVipMember();
      },
      builder: (_controller) {
        return Container(
          color: GolfColor.GolfGrayBackgroundColor,
          child: Column(
            children: [
              Container(
                height: 30.h,
                padding: const EdgeInsets.only(top: kToolbarHeight),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF241D59), Color(0xFF232F7C)],
                    stops: [0.0, 0.5225],
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.0.h,
                    horizontal: 15.0.sp,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Obx(
                        () => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Column(
                              spacing: 10,
                              children: [
                                (_controller.userInfo!.imagesPaths ?? "").isBlank!
                                    ? DefaultAvatar()
                                    : Avatar(
                                  avatarPath:
                                  '$GOLF_CORE_API_URL$USER_AVATAR_PATH${_controller.userInfo!.imagesPaths}',
                                ),
                                Column(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      _controller.userInfo!.fullName ?? '',
                                      style: themeData.textTheme.headlineSmall!
                                          .copyWith(fontSize: 14, fontWeight:
                                      FontWeight.bold, color: Colors.white),
                                    ),
                                    SizedBox(height: 2),
                                    Visibility(
                                      visible:
                                      _controller.userInfo!.confirmEmail ==
                                          ConfirmEmailStatus.UNCONFIRMED,
                                      child: InkWell(
                                        onTap:
                                        (() => Get.toNamed(
                                          AppRoutes.PROFILE,
                                        )!.then(
                                              (value) =>
                                              controller.updateUserInfo(),
                                        )),
                                        child: Text(
                                          '(${'unverified_account'.tr})',
                                          style: themeData.textTheme.titleSmall!
                                              .copyWith(
                                            color: themeData.colorScheme.error,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (controller.userInfo!.isUserManager ?? false)
                              Image.asset(
                                "assets/icons/person_vip.png",
                                width: 48,
                                color: Colors.white.withOpacity(0.8),
                              ),
                          ],
                        ),
                        _buildMyVipMember(themeData, controller.totalVipMembers),
                      ],
                    ),
                  ),
                ),
              ),

              Transform.translate(
                offset: Offset(0, -60),
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)
                        ),
                      color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        settingItem(context, 'account_infomation'.tr, () {
                          Get.toNamed(
                            AppRoutes.PROFILE,
                          )!.then((value) => controller.updateUserInfo());
                        }, Icons.people_alt),
                        settingItem(context, 'transaction_history'.tr, () {
                          Get.toNamed(AppRoutes.TRANSACTION_HISTORY);
                        }, Icons.history),
                        settingItem(context, 'buy_vip_member'.tr, () {
                          Get.toNamed(
                            AppRoutes.BUY_VIP_SHOP_LIST,
                          )!.then((_) => controller.getMyVipMember());
                        }, Icons.card_membership),
                        settingItem(context, 'favorite_shop'.tr, () {
                          Get.toNamed(AppRoutes.FAVORITE_SHOP);
                        }, Icons.favorite),
                        settingItem(context, 'change_language'.tr, () {
                          Get.to(ChangeLanguageScreen());
                        }, Icons.language),
                        settingItem(context, 'change_theme'.tr, () {
                          Get.to(ChangeThemeModeScreen());
                        }, Icons.format_paint_sharp),
                        settingItem(context, 'change_password'.tr, () async {
                          var _changePasswordResult = await Get.toNamed(
                            AppRoutes.CHANGE_PASSWORD,
                          );
                          if (_changePasswordResult != null &&
                              (_changePasswordResult as PageResult)
                                      .resultCode ==
                                  PageResultCode.OK) {
                            SupportUtils.showToast(
                              'change_password_success'.tr,
                              type: ToastType.SUCCESSFUL,
                            );
                          }
                        }, Icons.lock),
                        settingItem(context, 'about_app'.tr, () {
                          Get.to(AboutAppScreen());
                        }, Icons.info_outline, color: Color(0xff8E99FF)),
                        settingItem(context, 'sign_out'.tr, () {
                          SupportUtils.letsLogout();
                          Get.offAllNamed(AppRoutes.LOGIN);
                        }, Icons.format_paint_sharp),
                        SizedBox(height: 10),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildMyVipMember(ThemeData appTheme, int total) {
    return total == 0
        ? Container()
        : Padding(
          padding: EdgeInsets.only(top: 15.0.sp),
          child: Pressable(
            padding: EdgeInsets.all(10.0.sp),
            backgroundColor: appTheme.colorScheme.secondary,
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'vip_member'.tr,
                      style: appTheme.textTheme.headlineLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    // Text(
                    //   '(${'owning'.tr} $total ${'cards'.tr.toLowerCase()})',
                    //   style: appTheme.textTheme.titleSmall
                    //       .copyWith(color: Colors.white),
                    // ),
                  ],
                ),
                Icon(Icons.arrow_right, color: Colors.white, size: 5.0.w),
              ],
            ),
            onPress: () => Get.toNamed(AppRoutes.MY_VIP_LIST),
          ),
        );
  }
}
