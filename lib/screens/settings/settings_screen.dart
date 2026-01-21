import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/page_result.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/screens/about_app/about_app.dart';
import 'package:golf_uiv2/screens/change_language/change_language_scree.dart';
import 'package:golf_uiv2/screens/settings/settings_controller.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/widgets/avatar.dart';
import 'package:golf_uiv2/widgets/default_avatar.dart';
import 'package:golf_uiv2/widgets/settings_item.dart';
import 'package:golf_uiv2/utils/support.dart';

import '../../model/decision_option.dart';
import '../../utils/keys.dart';

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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF241D59), Color(0xFF232F7C)],
                    stops: [0.0, 0.5225],
                  ),
                ),
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          spacing: 10,
                          children: [
                            SizedBox(height: kTextTabBarHeight),
                            (_controller.userInfo!.imagesPaths ?? "").isBlank!
                                ? DefaultAvatar()
                                : Avatar(
                                  avatarPath:
                                      '$GOLF_CORE_API_URL$USER_AVATAR_PATH${_controller.userInfo!.imagesPaths}',
                                ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Text(
                                  _controller.userInfo!.fullName ?? '',
                                  style: themeData.textTheme.headlineSmall!
                                      .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                                // Visibility(
                                //   visible:
                                //   _controller.userInfo!.confirmEmail ==
                                //       ConfirmEmailStatus.UNCONFIRMED,
                                //   child: InkWell(
                                //     onTap:
                                //     (() => Get.toNamed(
                                //       AppRoutes.PROFILE,
                                //     )!.then(
                                //           (value) =>
                                //           controller.updateUserInfo(),
                                //     )),
                                //     child: Text(
                                //       '(${'unverified_account'.tr})',
                                //       style: themeData.textTheme.titleSmall!
                                //           .copyWith(
                                //         color: themeData.colorScheme.error,
                                //         fontStyle: FontStyle.italic,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                _buildMyVipMember(
                                  themeData,
                                  controller.totalVipMembers,
                                ),
                                if (controller.userInfo!.isUserManager ?? false)
                                  Image.asset(
                                    "assets/icons/person_vip.png",
                                    width: 24,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: GolfColor.GolfGrayBackgroundColor,
                    gradient: LinearGradient(
                      tileMode: TileMode.mirror,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF232F7C),
                        GolfColor.GolfGrayBackgroundColor,
                      ],
                      stops: [
                        0.2, // 10% trên là xanh
                        0.2, // từ 10% trở đi là trắng
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            settingItem(context, 'account_infomation'.tr, () {
                              Get.toNamed(
                                AppRoutes.PROFILE,
                              )!.then((value) => controller.updateUserInfo());
                            }, Icons.person),
                            if (SupportUtils.prefs.getInt(USER_TYPE_ID) == 3)
                              settingItem(
                                context,
                                'transaction_history'.tr,
                                () {
                                  Get.toNamed(AppRoutes.TRANSACTION_HISTORY);
                                },
                                Icons.history,
                              ),
                            if (SupportUtils.prefs.getInt(USER_TYPE_ID) == 3)
                              settingItemWithImage(
                                context,
                                'buy_vip_member'.tr,
                                () {
                                  Get.toNamed(
                                    AppRoutes.BUY_VIP_SHOP_LIST,
                                  )!.then((_) => controller.getMyVipMember());
                                },
                                "assets/images/member.png",
                              ),
                            settingItem(context, 'favorite_shop'.tr, () {
                              Get.toNamed(AppRoutes.FAVORITE_SHOP);
                            }, Icons.favorite),
                            settingItem(context, 'change_language'.tr, () {
                              Get.to(ChangeLanguageScreen());
                            }, Icons.language),
                            // settingItem(context, 'change_theme'.tr, () {
                            //   Get.to(ChangeThemeModeScreen());
                            // }, Icons.format_paint_sharp),
                            settingItemWithImage(
                              context,
                              'change_password'.tr,
                              () async {
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
                              },
                              "assets/images/lock.png",
                            ),
                            settingItem(
                              context,
                              'about_app'.tr,
                              () {
                                Get.to(AboutAppScreen());
                              },
                              Icons.info_outline,
                              color: Color(0xff8E99FF),
                            ),
                            settingItemWithImage(
                              context,
                              'sign_out'.tr,
                              () async {
                                SupportUtils.showDecisionDialog(
                                  "sign_out_confirmation_title".tr,
                                  lstOptions: [
                                    DecisionOption(
                                      'cancel'.tr,
                                      onDecisionPressed: null,
                                    ),

                                    DecisionOption(
                                      'yes'.tr,
                                      type: DecisionOptionType.DENIED,
                                      isImportant: true,
                                      onDecisionPressed: () {
                                        SupportUtils.letsLogout();
                                        Get.offAllNamed(AppRoutes.LOGIN);
                                      },
                                    ),
                                  ],
                                );
                              },
                              "assets/images/sign_out.png",
                              color: Color(0xffFFACAC),
                            ),
                          ],
                        ),
                      ),
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
        : InkWell(
          child: Text(
            'vip_member'.tr,
            style: appTheme.textTheme.titleSmall!.copyWith(
              color: appTheme.colorScheme.secondary,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () => Get.toNamed(AppRoutes.MY_VIP_LIST),
        );
  }
}
