import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:golf_uiv2/utils/size_config.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/pressable.dart';
import 'package:sizer/sizer.dart';

class TimeFilter extends StatelessWidget {
  const TimeFilter(this.fromDate, this.toDate,
      {Key? key,
      this.onFromDateChanged,
      this.onToDateChanged,
      this.onRequestSearch})
      : super(key: key);

  final DateTime fromDate;
  final DateTime toDate;
  final void Function(DateTime date)? onFromDateChanged;
  final void Function(DateTime date)? onToDateChanged;
  final void Function()? onRequestSearch;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _buildDateSelect(
              appTheme,
              "from".tr,
              fromDate
                  .endOfDay()
                  .millisecondsSinceEpoch
                  .toStringFormatSimpleDate(),
              () => _showPickDateDialog(
                context,
                appTheme,
                fromDate,
                (date) {
                  onFromDateChanged?.call(date);
                  onRequestSearch?.call();
                },
              ),
            ),
            SizedBox(width: 5.0.sp),
            _buildDateSelect(
              appTheme,
              "to".tr,
              toDate
                  .endOfDay()
                  .millisecondsSinceEpoch
                  .toStringFormatSimpleDate(),
              () => _showPickDateDialog(
                context,
                appTheme,
                toDate,
                (date) {
                  onToDateChanged?.call(date);
                  onRequestSearch?.call();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 6.0.sp),
        Align(
          alignment: Alignment.center,
          child: Pressable(
            onPress: onRequestSearch,
            backgroundColor: const Color(0xFF08D586),
            borderRadius: BorderRadius.circular(7.0.sp),
            padding: EdgeInsets.symmetric(
              vertical: 5.0.sp,
              horizontal: 18.0.sp,
            ),
            child: Text(
              'search_short'.tr,
              style: appTheme.textTheme.headlineSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 9.4.sp,
                height: 1.1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildDateSelect(
    ThemeData appTheme,
    String title,
    String value,
    void Function() onPressed,
  ) =>
      Expanded(
        child: Pressable(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: appTheme.textTheme.titleSmall!.copyWith(
                      color: appTheme.colorScheme.onSurface,
                      fontSize: 8.8.sp,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 1.0.sp),
                  Text(
                    value,
                    style: appTheme.textTheme.headlineSmall!.copyWith(
                      color: appTheme.colorScheme.surface,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.2.sp,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 4.8.w,
              )
            ],
          ),
          backgroundColor: appTheme.colorScheme.onBackground,
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(9.0.sp),
          padding: EdgeInsets.symmetric(
            vertical: 9.0.sp,
            horizontal: 12.0.sp,
          ),
          onPress: onPressed,
        ),
      );

  _showPickDateDialog(
    BuildContext context,
    ThemeData appTheme,
    DateTime currentDate,
    void Function(DateTime date)? onDateChanged,
  ) =>
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          builder: (BuildContext builder) {
            return Container(
              height: 32.h,
              width: 100.w,
              color: Colors.white,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: CupertinoTextThemeData()
                        .dateTimePickerTextStyle
                        .copyWith(
                          color: appTheme.textTheme.headlineSmall!.color,
                          fontFamily: appTheme.textTheme.headlineSmall!.fontFamily,
                        ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  backgroundColor: appTheme.colorScheme.onBackground,
                  onDateTimeChanged: (value) => onDateChanged?.call(value),
                  initialDateTime: currentDate.endOfDay(),
                ),
              ),
            );
          });
}
