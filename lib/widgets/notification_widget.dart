import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:golf_uiv2/model/notification.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

Widget notificationItemView(ThemeData theme, NotificationItemModel noti) {
  var textStyle = theme.textTheme.headlineSmall!.copyWith(color: Colors.white);
  return InkWell(
    onTap: () => Get.toNamed(AppRoutes.BOOKING_DETAIL, arguments: noti.iD),
    child: Container(
      margin: EdgeInsets.only(bottom: 2.0.w, right: 2.0.w, left: 2.0.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: theme.colorScheme.backgroundCardColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Time Play
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6.0.w),
                  bottomLeft: Radius.circular(6.0.w),
                ),
                color: Color(0xffF5F6FF),
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/mail.png",
                  height: 48,
                  width: 48,
                  color: Color(0xff3F51BC),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 8,
            child: Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Color(0xff3F51BC),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Shop Name
                  AutoSizeText(
                    getTitleNotication(noti.typeID),
                    style: textStyle,
                    maxLines: 2,
                  ),
                  SizedBox(height: 1.0.h),

                  /// Shop address
                  AutoSizeText(
                    "shop".tr + ": " + noti.title!,
                    style: textStyle,
                    maxLines: 2,
                  ),
                  SizedBox(height: 4),
                  AutoSizeText(
                    "at".tr + ": " + noti.message!,
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Color? getColorNotication(int? type) {
  Color? color = Colors.white;
  switch (type) {
    case NotificationType.BOOKING_CREATE:
      color = Colors.grey[300];
      break;
    case NotificationType.BOOKING_CANCEL:
      color = Colors.red[400];
      break;
    case NotificationType.BOOKING_CANCEL_BY_PAYMENT:
      color = Colors.red[400];
      break;
    case NotificationType.PAYMENT_SUCCESS:
      color = GolfColor.GolfPrimaryColor;
      break;
  }
  return color;
}

String getTitleNotication(int? type) {
  String string = '';
  switch (type) {
    case NotificationType.BOOKING_CREATE:
      string = 'book_success'.tr;
      break;
    case NotificationType.BOOKING_CANCEL:
      string = 'canceled_booking'.tr;
      break;
    case NotificationType.BOOKING_CANCEL_BY_PAYMENT:
      string = 'cancel_booking_by_payment'.tr;
      break;
    case NotificationType.PAYMENT_SUCCESS:
      string = 'payment_success_at'.tr;
      break;
  }
  return string;
}
