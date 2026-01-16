import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/block_model.dart';
import 'package:golf_uiv2/model/slot_model.dart';
import 'package:golf_uiv2/screens/booking_create/booking_create_controller.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';
import 'package:sizer/sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:golf_uiv2/utils/support.dart';

import '../model/user_vip_member.dart';

/// Tính toán ngày tối đa cho date picker
/// So sánh giữa hạn dùng VIP (nếu là user VIP) và nextDay, lấy ngày nhỏ hơn
DateTime getMaximumBookingDate(int nextDay) {
  final nextDayDate = DateTime.now().add(Duration(days: nextDay)).startOfDay();
  
  // Kiểm tra nếu là user VIP (USER_TYPE_ID == 4)
  if (SupportUtils.prefs.getInt(USER_TYPE_ID) == 4) {
    final vipExpiryTimestamp = SupportUtils.prefs.getInt(USER_DATE_EXPRIED_VIP);
    if (vipExpiryTimestamp != null && vipExpiryTimestamp > 0) {
      final vipExpiryDate = DateTime.fromMillisecondsSinceEpoch(
        vipExpiryTimestamp * 1000,
      ).startOfDay();
      // Trả về ngày nhỏ hơn
      return vipExpiryDate.isBefore(nextDayDate) ? vipExpiryDate : nextDayDate;
    }
  }
  
  return nextDayDate;
}

/// Tính số ngày còn lại có thể đặt booking
int getMaximumBookingDays(int nextDay) {
  final maxDate = getMaximumBookingDate(nextDay);
  final today = DateTime.now().startOfDay();
  return maxDate.difference(today).inDays;
}

Widget choosePaymentMethod(
  BuildContext context,
  ThemeData themeData,
  BookingCreateController controller,
  List<UserVipMember> lstPaymentMethod,
) {
  final selectedPayment = controller.selectedPaymentMethod;
  final isExpanded = controller.isPaymentMethodExpanded;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: themeData.colorScheme.backgroundCardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        // Header
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius:
                isExpanded
                    ? BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    )
                    : BorderRadius.circular(12),
            onTap: () {
              controller.onTogglePaymentMethodExpanded();
            },
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.payment_rounded,
                      size: 22,
                      color: Colors.purple[700],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'payment_method'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          selectedPayment?.nameCodeMember ??
                              'select_payment_method'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color:
                                selectedPayment != null
                                    ? GolfColor.GolfSubColor
                                    : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (lstPaymentMethod.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${lstPaymentMethod.length}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.purple[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Expandable content
        if (isExpanded && lstPaymentMethod.isNotEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFF8F5FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children:
                    lstPaymentMethod.map((payment) {
                      final isSelected =
                          controller.selectedPaymentMethod?.userCodeMemberId ==
                          payment.userCodeMemberId;
                      return InkWell(
                        onTap: () {
                          controller.onSelectPaymentMethod(payment);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          margin: EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? GolfColor.GolfPrimaryColor
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? GolfColor.GolfPrimaryColor
                                      : Colors.grey[300]!,
                              width: 1.5,
                            ),
                            boxShadow:
                                isSelected
                                    ? [
                                      BoxShadow(
                                        color: GolfColor
                                            .GolfPrimaryColor.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ]
                                    : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_off,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.grey[400],
                                size: 22,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  payment.nameCodeMember ?? '',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : GolfColor.GolfSubColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
      ],
    ),
  );
}

Widget chooseDateBooking(
  BuildContext context,
  ThemeData themeData,
  BookingCreateController controller,
  int nextDay,
  Function(DateTime) onDateChanged,
) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: themeData.colorScheme.backgroundCardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Lưu giá trị ban đầu để so sánh
          final initialDate =
              DateTime.fromMillisecondsSinceEpoch(
                controller.dateIntCurrent! * 1000,
                isUtc: true,
              ).startOfDay();

          // Lưu giá trị tạm khi scroll picker
          DateTime? tempSelectedDate = initialDate;

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useRootNavigator: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext builder) {
              return Container(
                height: 35.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: CupertinoTextThemeData()
                                .dateTimePickerTextStyle
                                .copyWith(
                                  color:
                                      themeData.textTheme.headlineSmall!.color,
                                  fontFamily:
                                      themeData
                                          .textTheme
                                          .headlineSmall!
                                          .fontFamily,
                                ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          minimumDate: DateTime.now().startOfDay(),
                          maximumDate: getMaximumBookingDate(nextDay),
                          onDateTimeChanged: (DateTime date) {
                            // Chỉ lưu tạm, chưa gọi callback
                            tempSelectedDate = date;
                          },
                          use24hFormat: true,
                          initialDateTime: tempSelectedDate,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ).then((_) {
            // Chỉ gọi callback nếu giá trị thực sự thay đổi
            if (tempSelectedDate != null &&
                tempSelectedDate!.millisecondsSinceEpoch !=
                    initialDate.millisecondsSinceEpoch) {
              onDateChanged(tempSelectedDate!);
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GolfColor.GolfPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  size: 22,
                  color: GolfColor.GolfPrimaryColor,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'select_date'.tr,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      controller.textDayOfWeek,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: GolfColor.GolfSubColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${getMaximumBookingDays(nextDay)} ${'days'.tr}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget chooseSlotBooking(
  BookingCreateController bookingCreateController,
  BuildContext context,
  ThemeData themeData,
  List<SlotItemModel> lstSlot,
) {
  final isExpanded = bookingCreateController.isMachineExpanded;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: themeData.colorScheme.backgroundCardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        // Header
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius:
                isExpanded
                    ? BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    )
                    : BorderRadius.circular(12),
            onTap: () {
              bookingCreateController.onChangeSlotExpanded();
            },
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.grid_view_rounded,
                      size: 22,
                      color: Colors.orange[700],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'select_machine'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2),
                        Obx(
                          () => Text(lstSlot.firstWhere((e) => e.isSelect,
                                  orElse: () => SlotItemModel())
                              .nameSlot ??
                              'choose_slot'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: GolfColor.GolfSubColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (lstSlot.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${lstSlot.length}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Expandable content
        if (isExpanded && lstSlot.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF5F6FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: lstSlot.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2.8,
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return chooseItemSlotViewCell(
                  bookingCreateController,
                  lstSlot[index],
                );
              },
            ),
          ),
      ],
    ),
  );
}

// 1 => Machine , 2 => Slot
Widget chooseItemSlotViewCell(
  BookingCreateController bookingCreateController,
  SlotItemModel slotItemModel,
) {
  final isSelected = slotItemModel.isSelect;

  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        bookingCreateController.onChangeSlotExpanded(item: slotItemModel);
        bookingCreateController.getBlock();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? GolfColor.GolfPrimaryColor : Colors.white,
          border: Border.all(
            color: isSelected ? GolfColor.GolfPrimaryColor : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: GolfColor.GolfPrimaryColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        alignment: Alignment.center,
        child: AutoSizeText(
          slotItemModel.nameSlot!,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isSelected ? Colors.white : GolfColor.GolfSubColor,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          minFontSize: 8,
        ),
      ),
    ),
  );
}

Widget chooseBlockBooking(
  BookingCreateController bookingCreateController,
  BuildContext context,
  ThemeData themeData,
  List<BlockItemModel> lstBlock,
  String nameCreditCard,
  bool isEnableBadge,
) {
  final isExpanded = bookingCreateController.isBlockExpanded;

  // Check if blocks have mixed types (both VIP and VISA)
  final hasVip = lstBlock.any((b) => b.isBlockCodeMember == true);
  final hasVisa = lstBlock.any((b) => b.isBlockCodeMember == false);
  final showLegend = hasVip && hasVisa;

  return Container(
    margin: EdgeInsets.only(right: 10, left: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: themeData.colorScheme.backgroundCardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        // Header
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius:
                isExpanded
                    ? BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    )
                    : BorderRadius.circular(12),
            onTap: () {
              bookingCreateController.onChangeBlockExpanded();
            },
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.access_time_rounded,
                      size: 22,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'select_time'.tr,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          bookingCreateController.slotValue,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: GolfColor.GolfSubColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // if (lstBlock.isNotEmpty)
                  //   Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //     decoration: BoxDecoration(
                  //       color: Colors.green[50],
                  //       borderRadius: BorderRadius.circular(6),
                  //     ),
                  //     child: Text(
                  //       '${lstBlock.where((b) => b.isSelect && b.isBooking).length}/${lstBlock.length}',
                  //       style: GoogleFonts.inter(
                  //         fontSize: 11,
                  //         color: Colors.green[700],
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Legend (only show if there are both VIP and VISA blocks)
        if (isExpanded && showLegend)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFF5F6FF),
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1A1F71), Color(0xFF2D4AA8)],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      nameCreditCard,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: GolfColor.GolfSubColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber[600]!, Colors.orange[400]!],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        bookingCreateController
                                .selectedPaymentMethod
                                ?.nameCodeMember ??
                            'VIP Member',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: GolfColor.GolfSubColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        // Expandable content
        if (isExpanded && lstBlock.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF5F6FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: lstBlock.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2.4,
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return chooseItemBlockViewCell(
                  bookingCreateController,
                  lstBlock[index],
                  isEnableBadge,
                );
              },
            ),
          ),
      ],
    ),
  );
}

Widget chooseItemBlockViewCell(
  BookingCreateController bookingCreateController,
  BlockItemModel blockItemModel,
  bool isEnableBadge,
) {
  // Check if block is bookable (time constraint: date + block time + 10min > now)
  final isTimeValid = bookingCreateController.isBlockBookable(blockItemModel);
  final isActive =
      blockItemModel.isActive! && blockItemModel.isBooking && isTimeValid;
  final isSelected = blockItemModel.isSelect;

  // Xác định badge type
  Widget? badge;
  if (blockItemModel.isBlockCodeMember == true) {
    // VIP badge - vertical text, full height
    badge = Container(
      width: 10,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.amber[600]!, Colors.orange[400]!],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          bottomLeft: Radius.circular(6),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 3),
    );
  } else if (blockItemModel.isBlockCodeMember == false) {
    // VISA badge - vertical text, full height
    badge = Container(
      width: 10,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1F71), Color(0xFF2D4AA8)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          bottomLeft: Radius.circular(6),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 3),
    );
  }

  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap:
          isActive
              ? () {
                bookingCreateController.onChangeBlockExpanded(
                  item: blockItemModel,
                );
              }
              : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              !isActive
                  ? Colors.grey[200]
                  : isSelected
                  ? GolfColor.GolfPrimaryColor
                  : Colors.white,
          border: Border.all(
            color:
                !isActive
                    ? Colors.grey[300]!
                    : isSelected
                    ? GolfColor.GolfPrimaryColor
                    : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: GolfColor.GolfPrimaryColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          children: [
            // Badge phía trước, full height
            if (badge != null && isEnableBadge) badge,
            // Time text
            Expanded(
              child: Center(
                child: AutoSizeText(
                  blockItemModel.getNameBlock(),
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color:
                        !isActive
                            ? Colors.grey[400]
                            : isSelected
                            ? Colors.white
                            : GolfColor.GolfSubColor,
                  ),
                  maxLines: 1,
                  minFontSize: 8,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
