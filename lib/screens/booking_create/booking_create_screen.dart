import 'package:flutter/material.dart';
import 'package:golf_uiv2/model/decision_option.dart';
import 'package:golf_uiv2/model/page_result.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:golf_uiv2/widgets/booking_create_widget.dart';
import 'package:golf_uiv2/widgets/booking_item.dart';
import 'package:golf_uiv2/widgets/button_default.dart';
import 'package:golf_uiv2/widgets/pressable_text.dart';
import 'package:sizer/sizer.dart';

import 'booking_create_controller.dart';

class BookingCreateScreen extends GetView<BookingCreateController> {
  final BookingCreateController bookingController = Get.put(BookingCreateController());
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return GetX<BookingCreateController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeData.colorScheme.background,
          body: Flex(
            direction: Axis.vertical,
            children: [
              /// Booking Information
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => Stack(
                    children: [
                      shopItemView(
                        themeData,
                        controller.shopSelected!,
                        onFavoriteChanged:
                            (val) => controller.changeFavorite(
                              controller.shopSelected!.shopID,
                            ),
                      ),
                      (controller.shopSelected!.countMemberCode! > 0)
                          ? Positioned(
                            bottom: 15.0.sp,
                            right: 45.0.sp,
                            child: _buildBuyVipMemberButton(
                              themeData,
                              onPressed:
                                  () => Get.toNamed(
                                    AppRoutes.BUY_VIP_LIST,
                                    arguments: controller.shopSelected,
                                  )!.then(
                                    (res) => _registerVipMemberBacked(res),
                                  ),
                            ),
                          )
                          : Container(),
                    ],
                  ),
                ),
              ),

              // / Booking time chooser
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity, // <-----
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                        bottom: 90,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6.0.w),
                          topRight: Radius.circular(6.0.w),
                        ),
                        color: GolfColor.GolfPrimaryColor,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
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

                            /// Choose machine
                            chooseSlotBooking(
                              controller,
                              context,
                              themeData,
                              controller.lstSlot,
                            ),
                            SizedBox(height: 10),
                            chooseBlockBooking(
                              controller,
                              context,
                              themeData,
                              controller.lstBlock,
                            ),
                            SizedBox(height: 45.0.sp),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(
                          bottom: 20,
                          right: 20,
                          left: 20,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DefaultButton(
                                text: 'cancel'.tr,
                                textColor: Colors.white,
                                backgroundColor: Colors.black54,
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
                                backgroundColor: Colors.amber,
                                press: () {
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
                                      DecisionOption(
                                        'no'.tr,
                                        onDecisionPressed: null,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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

  _registerVipMemberBacked(PageResult? result) {
    final controller = Get.find<BookingCreateController>();
    if (result != null && result.resultCode == PageResultCode.OK) {
      controller.getShopDetail();
      SupportUtils.showToast(
        "register_vip_member_successful".tr,
        type: ToastType.SUCCESSFUL,
      );
    }
  }
}
