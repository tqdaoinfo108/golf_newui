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
  return InkWell(
    onTap: () =>  Get.toNamed(AppRoutes.BOOKING_DETAIL, arguments: noti.iD),
    child: Container(
      margin: EdgeInsets.only(bottom: 2.0.w, right: 2.0.w, left: 2.0.w),
      padding: EdgeInsets.all(1.0.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: theme.colorScheme.backgroundCardColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Time Play
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              height: 26.0.w,
              width: 26.0.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: theme.scaffoldBackgroundColor),
              child: Center(
                child: Icon(Icons.calendar_today_rounded,
                    color: getColorNotication(noti.typeID), size: 6.0.h),
              ),
            ),
          ),
          SizedBox(width: 2.0.h),

          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Shop Name
                AutoSizeText(
                  getTitleNotication(noti.typeID),
                  style: theme.textTheme.headlineSmall,
                  maxLines: 2,
                ),
                SizedBox(height: 1.0.h),

                /// Shop address
                AutoSizeText(
                  "shop".tr + ": " + noti.title!,
                  style: theme.textTheme.titleSmall,
                  maxLines: 2,
                ),
                SizedBox(height: 1.0.h),
                AutoSizeText(
                  "at".tr + ": " + noti.message!,
                  style: theme.textTheme.titleSmall,
                ),
              ],
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
