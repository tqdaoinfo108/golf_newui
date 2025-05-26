import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/booking.dart';
import 'package:golf_uiv2/model/my_booking.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:sizer/sizer.dart';

Widget bookingItemView(ThemeData theme, Booking booking, Function onTap) {
  final currentDateTimeMili =
      DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
      ).millisecondsSinceEpoch;

  Color bgColor =
      (booking.statusID == BookingStatus.PAID ||
              booking.statusID == BookingStatus.USED)
          ? (((booking.blocks!.last.rangeEnd! - currentDateTimeMili) >= 0)
              ? Color(0xff4053BF)
              : Color(0xff8C98D9))
          : Color(0xff8C98D9);

  var titleBold = theme.textTheme.headlineMedium!.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  var titleSub = theme.textTheme.headlineSmall!.copyWith(color: Colors.white70);
  return InkWell(
    onTap: () => onTap.call(),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: bgColor,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// Shop Name
                    Text(booking.nameShop ?? "", style: titleBold),

                    /// Shop address
                    Text(booking.addressShop ?? "", style: titleSub),
                    Text(
                      "${booking.getBookingCurrent()!.rangeStart!.toStringFormatHoursUTC()} - ${booking.getBookingCurrent()!.rangeEnd!.toStringFormatHoursUTC()}",
                      style: titleBold,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text("slot".tr, style: titleSub),
                            Text(
                              "${booking.nameSlot}",
                              style: titleBold,
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Text("price".tr, style: titleSub),
                            Text(
                              "${booking.blocks!.fold(0.0, (sum, block) => sum + block.price!)}",
                              style: titleBold,
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),

                    /// Payment status
                    // Container(
                    //   padding: EdgeInsets.only(
                    //     top: 4,
                    //     bottom: 4,
                    //     right: 8,
                    //     left: 8,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(20)),
                    //     color:
                    //         booking.statusID == BookingStatus.CANCELED
                    //             ? Colors.red
                    //             : colorStatus,
                    //   ),
                    //   child:
                    //       (booking.statusID == BookingStatus.PAID ||
                    //               booking.statusID == BookingStatus.USED)
                    //           ? Text(
                    //             'paid'.tr,
                    //             style: theme.textTheme.titleSmall!.copyWith(
                    //               fontSize: 8.0.sp,
                    //               color: Colors.white,
                    //             ),
                    //           )
                    //           : (booking.statusID == BookingStatus.WAITING_PAYMENT
                    //               ? Text(
                    //                 'waiting_payment'.tr,
                    //                 style: theme.textTheme.titleSmall!.copyWith(
                    //                   fontSize: 8.0.sp,
                    //                   color: Colors.black,
                    //                 ),
                    //               )
                    //               : Text(
                    //                 'canceled'.tr,
                    //                 style: theme.textTheme.titleSmall!.copyWith(
                    //                   fontSize: 8.0.sp,
                    //                   color: Colors.white,
                    //                 ),
                    //               )),
                    // ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          blurRadius: 7, // Độ mờ của bóng
                          offset: Offset(0, 3), // Vị trí bóng (x, y)
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      color: Color(0xffF5F6FF),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Text("usage".tr),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          color: bgColor,
                        ),
                        child:
                            (booking.statusID == BookingStatus.PAID ||
                                    booking.statusID == BookingStatus.USED)
                                ? Text(
                                  'paid'.tr,
                                  style: theme.textTheme.titleSmall!.copyWith(
                                    fontSize: 8.0.sp,
                                    color: Colors.white,
                                  ),
                                )
                                : (booking.statusID ==
                                        BookingStatus.WAITING_PAYMENT
                                    ? Text(
                                      'waiting_payment'.tr,
                                      style: theme.textTheme.titleSmall!
                                          .copyWith(
                                            fontSize: 7.0.sp,
                                            color: Colors.white,
                                          ),
                                    )
                                    : Text(
                                      'canceled'.tr,
                                      style: theme.textTheme.titleSmall!
                                          .copyWith(
                                            fontSize: 8.0.sp,
                                            color: Colors.white,
                                          ),
                                    )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget bookingTitleView(ThemeData theme, int dateInt) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    child: Text(
      dateInt.toStringFormatDateUTC(),
      style: theme.textTheme.headlineSmall!.copyWith(
        color: GolfColor.GolfSubColor,
      ),
    ),
  );
}

Widget bookingListItemView(
  ThemeData theme,
  MyBooking booking,
  Function(Booking) onTap,
) {
  List<Widget> listWidget = [];
  listWidget.add(bookingTitleView(theme, booking.date!));
  listWidget.add(SizedBox(height: 2.0.w));
  for (var item in booking.lstBooking!) {
    listWidget.add(
      bookingItemView(theme, item, () {
        onTap(item);
      }),
    );
  }
  return Container(
    padding: EdgeInsets.only(top: 1.0.h, right: 2.0.w, left: 2.0.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listWidget,
    ),
  );
}
