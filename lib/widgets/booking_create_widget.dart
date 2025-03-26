import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:golf_uiv2/model/block_model.dart';
import 'package:golf_uiv2/model/slot_model.dart';
import 'package:golf_uiv2/screens/booking_create/booking_create_controller.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';
import 'package:expandable/expandable.dart';
import 'package:sizer/sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:golf_uiv2/utils/support.dart';

Widget chooseDateBooking(
  BuildContext context,
  ThemeData themeData,
  BookingCreateController controller,
  int nextDay,
  Function(DateTime) onDateChanged,
) {
  return InkWell(
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (BuildContext builder) {
          return Container(
            height: 33.h,
            width: 100.w,
            color: Colors.white,
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: CupertinoTextThemeData()
                      .dateTimePickerTextStyle
                      .copyWith(
                        color: themeData.textTheme.headlineSmall!.color,
                        fontFamily:
                            themeData.textTheme.headlineSmall!.fontFamily,
                      ),
                ),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                minimumDate: DateTime.now().startOfDay(),
                maximumDate:
                    DateTime.now().add(Duration(days: nextDay)).startOfDay(),
                onDateTimeChanged: onDateChanged,
                initialDateTime:
                    DateTime.fromMillisecondsSinceEpoch(
                      controller.dateIntCurrent! * 1000,
                      isUtc: true,
                    ).endOfDay(),
              ),
            ),
          );
        },
      );
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 1.3.h, vertical: 2.0.h),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3.0.w)),
        color: themeData.colorScheme.backgroundCardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 6.0.w),
              SizedBox(width: 2.0.w),
              Text(
                controller.textDayOfWeek,
                style: themeData.textTheme.headlineSmall,
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            SupportUtils.interpolate('booking_next_day_limit'.tr, [nextDay]),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
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
  return Theme(
    data: themeData.copyWith(cardColor: themeData.colorScheme.background),
    child: ExpandablePanel(
      controller: bookingCreateController.exMachineController,
      theme: const ExpandableThemeData(
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        tapBodyToCollapse: true,
        hasIcon: false,
      ),
      header: InkWell(
        onTap: () {
          bookingCreateController.onChangeSlotExpanded();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 1.3.h, vertical: 2.0.h),
          margin: EdgeInsets.symmetric(horizontal: 10),

          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                blurRadius: 4, // Độ mờ của bóng
                offset: Offset(0, 3), // Vị trí bóng (x, y)
              ),
            ],
            borderRadius:
                bookingCreateController.exMachineController!.expanded
                    ? BorderRadius.only(
                      topLeft: Radius.circular(3.0.w),
                      topRight: Radius.circular(3.0.w),
                    )
                    : BorderRadius.all(Radius.circular(3.0.w)),
            color: themeData.colorScheme.backgroundCardColor,
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 6.0.w),
              SizedBox(width: 2.0.w),
              Text(
                bookingCreateController.machineValue!,
                style: themeData.textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
      expanded: Container(
        margin: EdgeInsets.only(right: 10, left: 10, bottom: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 4, // Độ mờ của bóng
              offset: Offset(0, 3), // Vị trí bóng (x, y)
            ),
          ],
          borderRadius:
              bookingCreateController.exMachineController!.expanded
                  ? BorderRadius.only(
                    bottomLeft: Radius.circular(3.0.w),
                    bottomRight: Radius.circular(3.0.w),
                  )
                  : BorderRadius.all(Radius.circular(3.0.w)),
          color: Color(0xffE6E9FF),
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(2.0.w),
          shrinkWrap: true,
          physics: new ScrollPhysics(),
          itemCount: lstSlot.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2.5,
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
      collapsed: Container(),
    ),
  );
}

// 1 => Machine , 2 => Slot
Widget chooseItemSlotViewCell(
  BookingCreateController bookingCreateController,
  SlotItemModel slotItemModel,
) {
  return InkWell(
    onTap: () {
      bookingCreateController.onChangeSlotExpanded(item: slotItemModel);
      bookingCreateController.getBlock();
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(1.0.h)),
        border: Border.all(color: Colors.black54),
        color: slotItemModel.isSelect ? GolfColor.GolfSubColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 4, // Độ mờ của bóng
            offset: Offset(0, 3), // Vị trí bóng (x, y)
          ),
        ],
      ),
      alignment: Alignment.center,
      child: AutoSizeText(
        slotItemModel.nameSlot!,
        style: GoogleFonts.openSans(
          fontSize: 12.0.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        maxLines: 1,
        minFontSize: 6,
      ),
    ),
  );
}

Widget chooseBlockBooking(
  BookingCreateController bookingCreateController,
  BuildContext context,
  ThemeData themeData,
  List<BlockItemModel> lstBlock,
) {
  return ExpandablePanel(
    controller: bookingCreateController.exSlotController,
    theme: const ExpandableThemeData(
      headerAlignment: ExpandablePanelHeaderAlignment.center,
      tapBodyToCollapse: true,
      hasIcon: false,
    ),
    header: InkWell(
      onTap: () {
        bookingCreateController.onChangeBlockExpanded();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.3.h, vertical: 2.0.h),
        margin: EdgeInsets.only(right: 10, left: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 4, // Độ mờ của bóng
              offset: Offset(0, 3), // Vị trí bóng (x, y)
            ),
          ],
          borderRadius:
              bookingCreateController.exSlotController!.expanded
                  ? BorderRadius.only(
                    topLeft: Radius.circular(3.0.w),
                    topRight: Radius.circular(3.0.w),
                  )
                  : BorderRadius.all(Radius.circular(3.0.w)),
          color: themeData.colorScheme.backgroundCardColor,
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 6.0.w),
            SizedBox(width: 2.0.w),
            Text(
              bookingCreateController.slotValue,
              style: themeData.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    ),
    expanded: Container(
      margin: EdgeInsets.only(right: 10, left: 10, bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius:
            bookingCreateController.exSlotController!.expanded
                ? BorderRadius.only(
                  bottomLeft: Radius.circular(3.0.w),
                  bottomRight: Radius.circular(3.0.w),
                )
                : BorderRadius.all(Radius.circular(3.0.w)),
        color: Color(0xffE6E9FF),
      ),
      child: GridView.builder(
        padding: EdgeInsets.all(8),
        shrinkWrap: true,
        physics: new ScrollPhysics(),
        itemCount: lstBlock.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2.5,
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return chooseItemBlockViewCell(
            bookingCreateController,
            lstBlock[index],
          );
        },
      ),
    ),
    collapsed: Container(),
  );
}

Widget chooseItemBlockViewCell(
  BookingCreateController bookingCreateController,
  BlockItemModel blockItemModel,
) {
  return InkWell(
    onTap: () {
      if (blockItemModel.isActive!) {
        bookingCreateController.onChangeBlockExpanded(item: blockItemModel);
      }
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(1.0.h)),
        border: Border.all(color: Colors.black54),
        color:
            blockItemModel.isActive!
                ? blockItemModel.isSelect
                    ? GolfColor.GolfPrimaryColor
                    : Colors.white
                : Color(0xff8C98D9),
      ),
      alignment: Alignment.center,
      child: AutoSizeText(
        blockItemModel.getNameBlock(),
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color:
              blockItemModel.isSelect
                  ? Colors.white
                  : GolfColor.GolfPrimaryColor,
        ),
        maxLines: 1,
        minFontSize: 6,
      ),
    ),
  );
}
