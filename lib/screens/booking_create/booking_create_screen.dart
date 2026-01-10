import 'package:flutter/material.dart';
import 'package:golf_uiv2/model/decision_option.dart';
import 'package:golf_uiv2/model/page_result.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/booking_create_widget.dart';
import 'package:golf_uiv2/widgets/booking_item.dart';
import 'package:golf_uiv2/widgets/button_default.dart';
import 'package:golf_uiv2/widgets/pressable_text.dart';
import 'package:sizer/sizer.dart';

import '../../model/shop_model.dart';
import '../../model/user_vip_member.dart';
import '../../utils/keys.dart';
import 'booking_create_controller.dart';

// ignore: must_be_immutable
class BookingCreateScreen extends GetView<BookingCreateController> {
  BookingCreateScreen(this.data, {super.key});
  ShopItemModel data;

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    controller.shopSelected = data;
    controller.getSlotFirst();

    return Obx(
      () => Scaffold(
        backgroundColor: themeData.colorScheme.background,
        extendBody: true,
        body: Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewPadding.bottom > 0
                    ? kToolbarHeight
                    : 0,
          ),
          child: Flex(
            direction: Axis.vertical,
            children: [
              /// Booking Information
              Container(
                padding: const EdgeInsets.only(
                  top: kToolbarHeight,
                  right: 10,
                  left: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF241D59), Color(0xFF232F7C)],
                    stops: [0.0, 0.5225],
                  ),
                ),
                child: Obx(
                  () => shopItemView(
                    themeData,
                    controller.shopSelected!,
                    onFavoriteChanged:
                        (val) => controller.changeFavorite(
                          controller.shopSelected!.shopID,
                        ),
                    buyVipMemberButton:
                        ((controller.shopSelected!.countMemberCode ?? 0) > 0 && SupportUtils.prefs.getInt(USER_TYPE_ID) != 4)
                            ? _buildBuyVipMemberButton(
                              themeData,
                              onPressed:
                                  () => Get.toNamed(
                                    AppRoutes.BUY_VIP_LIST,
                                    arguments: controller.shopSelected,
                                  )!.then(
                                    (res) => _registerVipMemberBacked(res),
                                  ),
                            )
                            : null,
                  ),
                ),
              ),

              // / Booking time chooser
              Expanded(
                child: SizedBox(
                  height: double.infinity, // <-----
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10),

                        /// Choose date
                        chooseDateBooking(
                          context,
                          themeData,
                          controller,
                          controller.shopSelected!.dayLimitBooking ?? 30,
                          (_value) {
                            controller.onDateChange(_value);
                          },
                        ),
                        SizedBox(height: 10),

                        /// Choose payment method
                        if (controller.lstPaymentMethod.isNotEmpty)
                          choosePaymentMethod(
                            context,
                            themeData,
                            controller,
                            controller.lstPaymentMethod,
                          ),
                        if (controller.lstPaymentMethod.isNotEmpty)
                          SizedBox(height: 10),

                        /// Choose machine (only enabled after payment method selected)
                        AbsorbPointer(
                          absorbing:
                              controller.lstPaymentMethod.isNotEmpty &&
                              !controller.isPaymentMethodSelected,
                          child: Opacity(
                            opacity:
                                controller.lstPaymentMethod.isEmpty ||
                                        controller.isPaymentMethodSelected
                                    ? 1.0
                                    : 0.5,
                            child: chooseSlotBooking(
                              controller,
                              context,
                              themeData,
                              controller.lstSlot,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        chooseBlockBooking(
                          controller,
                          context,
                          themeData,
                          controller.lstBlock,
                          controller.lstPaymentMethod
                                  .firstWhere(
                                    (x) => x.userCodeMemberId == 0,
                                    orElse:
                                        () => UserVipMember(
                                          userCodeMemberId: 0,
                                          nameCodeMember: "Credit Card",
                                        ),
                                  )
                                  .nameCodeMember ??
                              "Credit Card",
                          true,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(
                  bottom: 30,
                  right: 20,
                  left: 20,
                  top: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DefaultButton(
                        text: 'cancel'.tr,
                        textColor: Colors.white,
                        backgroundColor: Color(0xff4053BF),
                        radius: 15,
                        press: () {
                          controller.onCancelBooking();
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: DefaultButton(
                        text: 'create'.tr,
                        textColor: Colors.white,
                        backgroundColor: Color(0xff232E7A),
                        radius: 15,
                        press: () {
                          if (!controller.onValidateCreateBooking()) {
                            return;
                          }

                          SupportUtils.showDecisionDialog(
                            'are_you_sure_create_booking'.tr,
                            lstOptions: [
                              DecisionOption(
                                'yes'.tr,
                                type: DecisionOptionType.EXPECTATION,
                                onDecisionPressed: () {
                                  controller.onCreateBooking();
                                },
                              ),
                              DecisionOption('no'.tr, onDecisionPressed: null),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: kBottomNavigationBarHeight + 32),
            ],
          ),
        ),
      ),
    );
  }

  _buildBuyVipMemberButton(ThemeData appTheme, {void Function()? onPressed}) =>
      PressableText(
        "buy_vip_member".tr,
        style: appTheme.textTheme.titleSmall!.copyWith(
          color: appTheme.colorScheme.onSecondary,
        ),
        backgroundColor: appTheme.colorScheme.secondary,
        padding: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 3.0.sp),
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(3.0.sp),
        onPress: onPressed,
      );

  _registerVipMemberBacked(PageResult? result) async {
    final controller = Get.find<BookingCreateController>();
    if (result != null && result.resultCode == PageResultCode.OK) {
      await controller.getShopDetail();
      await controller.resetValue();
      SupportUtils.showToast(
        "register_vip_member_successful".tr,
        type: ToastType.SUCCESSFUL,
      );
    }
  }
}
