import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/booking.dart';
import 'package:golf_uiv2/model/my_booking.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

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

  final titleBold = GoogleFonts.inter(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 11.sp,
  );

  final titleBoldLarge = GoogleFonts.inter(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 13.sp,
  );

  final titleSub = GoogleFonts.inter(
    color: Colors.white70,
    fontWeight: FontWeight.w400,
    fontSize: 9.sp,
  );

  return InkWell(
    onTap: () => onTap.call(),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// Shop Name
                    Text(
                      booking.nameShop ?? "",
                      style: titleBoldLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),

                    /// Shop address
                    Text(
                      booking.addressShop ?? "",
                      style: titleSub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),

                    /// Time range
                    Text(
                      "${booking.getBookingCurrent()!.rangeStart!.toStringFormatHoursUTC()} - ${booking.getBookingCurrent()!.rangeEnd!.toStringFormatHoursUTC()}",
                      style: titleBold,
                    ),
                    SizedBox(height: 8),

                    /// Slot & Price row
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("slot".tr, style: titleSub),
                            SizedBox(height: 2),
                            Text("${booking.nameSlot}", style: titleBold),
                          ],
                        ),
                        SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("price".tr, style: titleSub),
                            SizedBox(height: 2),
                            Text(
                              "${booking.blocks!.fold(0.0, (sum, block) => sum + block.price!).toStringAsFixed(0)}",
                              style: titleBold,
                            ),
                          ],
                        ),
                      ],
                    ),
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
                          blurRadius: 7,
                          offset: Offset(0, 3),
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
                    children: [
                      if (booking.statusID == BookingStatus.USED)
                        Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            'used'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: const Color.fromARGB(255, 26, 18, 139),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          color: bgColor,
                        ),
                        child: _buildStatusText(booking, theme),
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

Widget _buildStatusText(Booking booking, ThemeData theme) {
  final statusStyle = GoogleFonts.inter(
    fontSize: 7.sp,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  if (booking.statusID == BookingStatus.PAID ||
      booking.statusID == BookingStatus.USED) {
    return Text('paid'.tr, style: statusStyle);
  } else if (booking.statusID == BookingStatus.WAITING_PAYMENT) {
    return Text('waiting_payment'.tr, style: statusStyle);
  } else {
    return Text('canceled'.tr, style: statusStyle);
  }
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
