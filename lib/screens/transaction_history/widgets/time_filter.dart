import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:golf_uiv2/utils/size_config.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/pressable.dart';
import 'package:golf_uiv2/widgets/pressable_text.dart';
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
                onFromDateChanged,
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
                onToDateChanged,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0.sp),
        PressableText(
          "search".tr,
          textAlign: TextAlign.center,
          backgroundColor: appTheme.colorScheme.primary,
          padding: EdgeInsets.all(10.0.sp),
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0.sp),
          onPress: onRequestSearch,
          style: appTheme.textTheme.headlineLarge!.copyWith(
            color: appTheme.colorScheme.onPrimary,
          ),
        )
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
                      fontSize: 9.0.sp,
                    ),
                  ),
                  Text(
                    value,
                    style: appTheme.textTheme.headlineSmall!.copyWith(
                      color: appTheme.colorScheme.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 5.0.w,
              )
            ],
          ),
          backgroundColor: appTheme.colorScheme.onBackground,
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0.sp),
          padding: EdgeInsets.symmetric(
            vertical: 10.0.sp,
            horizontal: 15.0.sp,
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
          builder: (BuildContext builder) {
            return Container(
              height: SizeConfig.withContext(context)!.screenHeight / 3,
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
