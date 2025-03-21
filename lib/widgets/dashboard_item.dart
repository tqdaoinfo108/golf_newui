import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/booking.dart';
import 'package:golf_uiv2/model/my_booking.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:sizer/sizer.dart';

Widget bookingItemView(ThemeData theme, Booking booking, Function onTap) {
  final currentDateTimeMili = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
  ).millisecondsSinceEpoch;

  Color colorStatus = (booking.statusID == BookingStatus.PAID ||
          booking.statusID == BookingStatus.USED)
      ? (((booking.blocks!.last.rangeEnd! - currentDateTimeMili) >= 0)
          ? Colors.green
          : Colors.grey)
      : Colors.grey;

  return InkWell(
    onTap: () => onTap.call(),
    child: Container(
      margin: EdgeInsets.only(bottom: 1.0.w),
      padding: EdgeInsets.all(2.0.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2.0.h)),
          color: theme.scaffoldBackgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Time Play
          Expanded(
            flex: 3,
            child: Stack(children: [
              Container(
                height: 26.0.w,
                width: 26.0.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: colorStatus),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Time Start
                      Text(
                        booking
                            .getBookingCurrent()!
                            .rangeStart!
                            .toStringFormatHoursUTC(),
                        style: theme.textTheme.headlineMedium,
                      ),
                      SizedBox(height: 3),

                      /// Time end
                      Text(
                        booking
                            .getBookingCurrent()!
                            .rangeEnd!
                            .toStringFormatHoursUTC(),
                        style: theme.textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ),
              booking.statusID == BookingStatus.USED
                  ? Positioned(
                      top: 5.0.sp,
                      right: 5.0.sp,
                      child: Icon(
                        Icons.check,
                        size: 18.0.sp,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            ]),
          ),
          SizedBox(width: 10),

          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// Shop Name
                Text(
                  booking.nameShop!,
                  style: theme.textTheme.headlineLarge,
                ),
                SizedBox(height: 4),

                /// Shop address
                Text(
                  booking.addressShop!,
                  style: theme.textTheme.titleSmall,
                ),
                SizedBox(height: 6),

                /// Payment status
                Container(
                    padding:
                        EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: booking.statusID == BookingStatus.CANCELED
                            ? Colors.red
                            : colorStatus),
                    child: (booking.statusID == BookingStatus.PAID ||
                            booking.statusID == BookingStatus.USED)
                        ? Text('paid'.tr,
                            style: theme.textTheme.titleSmall!
                                .copyWith(fontSize: 8.0.sp, color: Colors.white))
                        : (booking.statusID == BookingStatus.WAITING_PAYMENT
                            ? Text('waiting_payment'.tr,
                                style: theme.textTheme.titleSmall!.copyWith(
                                    fontSize: 8.0.sp, color: Colors.black))
                            : Text('canceled'.tr,
                                style: theme.textTheme.titleSmall!.copyWith(
                                    fontSize: 8.0.sp, color: Colors.white))))
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget bookingTitleView(ThemeData theme, int dateInt) {
  return Text(
    dateInt.toStringFormatDateUTC(),
    style: theme.textTheme.headlineSmall,
  );
}

Widget bookingListItemView(
    ThemeData theme, MyBooking booking, Function(Booking) onTap) {
  List<Widget> listWidget = [];
  listWidget.add(bookingTitleView(theme, booking.date!));
  listWidget.add(SizedBox(height: 2.0.w));
  for (var item in booking.lstBooking!) {
    listWidget.add(bookingItemView(theme, item, () {
      onTap(item);
    }));
  }
  return Container(
    padding: EdgeInsets.only(top: 1.0.h, right: 2.0.w, left: 2.0.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listWidget,
    ),
  );
}
