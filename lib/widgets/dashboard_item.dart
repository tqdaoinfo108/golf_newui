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
              ? Color(0xff4053BF) // Future/Active
              : Color(0xff8C98D9)) // Past
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

  // Determine price display lines from block payment split (member/visa)
  final priceDisplayLines = _getPriceDisplayLines(booking);

  return InkWell(
    onTap: () => onTap.call(),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Shop Name and (optional) Used status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.nameShop ?? "",
                      style: titleBoldLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      booking.addressShop ?? "",
                      style: titleSub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (booking.statusID == BookingStatus.USED)
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'used'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12),

          // Row 2: Time and Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${booking.getBookingCurrent()!.rangeStart!.toStringFormatHoursUTC()} - ${booking.getBookingCurrent()!.rangeEnd!.toStringFormatHoursUTC()}",
                style: titleBold,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.black.withOpacity(0.15),
                ),
                child: _buildStatusText(booking, theme),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Row 3: Slot and Price info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("select_machine".tr, style: titleSub),
                  SizedBox(height: 2),
                  Text(
                    "${booking.nameSlot ?? ''}(${booking.blocks?.length ?? 1})",
                    style: titleBold,
                  ),
                ],
              ),
              if (priceDisplayLines.isNotEmpty) SizedBox(width: 32),
              if (priceDisplayLines.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("price".tr, style: titleSub),
                    SizedBox(height: 2),
                    ...priceDisplayLines.map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          line,
                          style: titleBold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Determine price display lines based on IsVisa in blocks.
List<String> _getPriceDisplayLines(Booking booking) {
  if (_isSpecialMemberBooking(booking)) {
    return ['dashboard_special_member'.tr];
  }

  final blocks = booking.blocks ?? [];
  if (blocks.isEmpty) {
    return [];
  }

  // IsVisa = null/false => member, IsVisa = true => visa
  final hasMemberUsage = blocks.any((block) => block.isVisa != true);
  final hasCreditUsage = blocks.any((block) => block.isVisa == true);
  final visaTotal = _getVisaTotal(booking);

  final creditAmount = visaTotal.toStringAsFixed(0);
  final lines = <String>[];

  if (hasMemberUsage) {
    lines.add('${'dashboard_member_plan_usage'.tr}  ¥0');
  }
  if (hasCreditUsage) {
    lines.add('${'dashboard_credit_usage'.tr}  ¥$creditAmount');
  }

  return lines;
}

double _getVisaTotal(Booking booking) {
  final blocks = booking.blocks ?? [];
  final visaFromBlocks = blocks
      .where((block) => block.isVisa == true)
      .fold<double>(0, (sum, block) => sum + (block.amountAfterDiscount ?? 0));

  return visaFromBlocks;
}

bool _isSpecialMemberBooking(Booking booking) {
  return booking.isShopManager == true ||
      (booking.typeUserID != null &&
          booking.typeUserID != 3 &&
          booking.typeUserID != 4);
}

Widget _buildStatusText(Booking booking, ThemeData theme) {
  final statusStyle = GoogleFonts.inter(
    fontSize: 9.sp,
    color: Colors.white,
    fontWeight: FontWeight.w600,
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
        fontWeight: FontWeight.w600,
        fontSize: 14.sp,
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
    padding: EdgeInsets.only(top: 1.0.h, bottom: 0.5.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listWidget,
    ),
  );
}
