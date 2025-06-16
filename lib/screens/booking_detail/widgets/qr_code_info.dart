import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/booking.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/booking_item.dart';
import 'package:golf_uiv2/widgets/widget_custom.dart';
import 'package:sizer/sizer.dart';

QRCodeInfo(BuildContext context, String? qrCodeStr, Booking bookingDetail) {
  final appTheme = Theme.of(context);
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.0.sp),
      color: appTheme.colorScheme.onPrimary,
    ),
    child:Padding(
        padding: EdgeInsets.all(15.0.sp),
        child: Column(
          children: [
            createQRCode((qrCodeStr ?? '').replaceAll('\"', ''), width: 60.0.w),
            SizedBox(height: 5.0.w),
            bookingDetailSimpleItemView(
              appTheme,
              'shop'.tr,
              bookingDetail.nameShop!,
            ),
            SizedBox(height: 1.0.w),
            bookingDetailSimpleItemView(
              appTheme,
              'address'.tr,
              bookingDetail.addressShop!,
            ),
            SizedBox(height: 1.0.w),
            bookingDetailSimpleItemView(
              appTheme,
              'date_play'.tr,
              bookingDetail.datePlay!.toStringFormatDate(),
            ),
            SizedBox(height: 1.0.w),
            bookingDetailListBlockSimpleView(appTheme, bookingDetail.blocks!),
          ],
        ),
      ),
  );
}
