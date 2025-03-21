import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/booking.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/booking_item.dart';
import 'package:golf_uiv2/widgets/pressable.dart';
import 'package:golf_uiv2/widgets/widget_custom.dart';
import 'package:sizer/sizer.dart';

class QRCodeInfo extends StatelessWidget {
  const QRCodeInfo({Key? key, this.qrCodeStr, this.bookingDetail})
      : super(key: key);

  final String? qrCodeStr;
  final Booking? bookingDetail;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final expanded = true.obs;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0.sp),
        color: appTheme.colorScheme.onPrimary,
      ),
      child: Column(
        children: [
          Pressable(
            pressRadius: 10,
            padding: EdgeInsets.symmetric(
              horizontal: 15.0.sp,
              vertical: 10.0.sp,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.label,
                  color: appTheme.colorScheme.primary,
                  size: 5.0.w,
                ),
                SizedBox(width: 1.0.w),
                Text(
                  'ticket_information'.tr.toUpperCase(),
                  style: appTheme.textTheme.headlineSmall!
                      .copyWith(color: Colors.black),
                ),
                Expanded(child: Container()),
                Obx(
                  () => Icon(
                    expanded.value
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: Colors.black,
                    size: 5.0.w,
                  ),
                ),
              ],
            ),
            onPress: () => expanded.value = !expanded.value,
          ),
          Obx(
            () => AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: expanded.value ? 380.0.sp : 0,
              child: Padding(
                padding: EdgeInsets.all(15.0.sp),
                child: expanded.value
                    ? Column(
                        children: [
                          createQRCode((qrCodeStr ?? '').replaceAll('\"', ''),
                              width: 60.0.w),
                          SizedBox(height: 5.0.w),
                          bookingDetailSimpleItemView(
                              appTheme, 'shop'.tr, bookingDetail!.nameShop!),
                          SizedBox(height: 1.0.w),
                          bookingDetailSimpleItemView(appTheme, 'address'.tr,
                              bookingDetail!.addressShop!),
                          SizedBox(height: 1.0.w),
                          bookingDetailSimpleItemView(
                            appTheme,
                            'date_play'.tr,
                            bookingDetail!.datePlay!.toStringFormatDate(),
                          ),
                          SizedBox(height: 1.0.w),
                          bookingDetailListBlockSimpleView(
                              appTheme, bookingDetail!.blocks!),
                        ],
                      )
                    : Container(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
