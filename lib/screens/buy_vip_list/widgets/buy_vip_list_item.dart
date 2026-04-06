import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:golf_uiv2/model/shop_vip_memeber.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/pressable_text.dart';
import 'package:sizer/sizer.dart';

class BuyVipListItem extends StatelessWidget {
  const BuyVipListItem({
    Key? key,
    this.vipMemberItem,
    this.onRegisterPressed,
    this.shopName,
    this.availableRegister = true,
  }) : super(key: key);

  final ShopVipMember? vipMemberItem;
  final void Function()? onRegisterPressed;
  final bool availableRegister;
  final String? shopName;
  String _getPlayInMonth() {
    if (vipMemberItem == null) return "月の利用可能回数 : 制限なし";
    final val = vipMemberItem!.numberPlayInMonth;
    final suffix = (val == null || val == 0) ? "制限なし" : "${val}回";
    return "月の利用可能回数 : $suffix";
  }

  String _getPlayInDay() {
    if (vipMemberItem == null) return "1日の予約上限 : 制限なし";
    final val = vipMemberItem!.numberPlayInDay;
    final suffix = (val == null || val == 0) ? "制限なし" : "${val}回";
    return "1日の予約上限 : $suffix";
  }

  String _getConsecutive() {
    if (vipMemberItem == null) return "連続予約上限 : 制限なし";
    final val = vipMemberItem!.bookingConsecutiveLimit;
    final suffix = (val == 0) ? "制限なし" : "${val}回";
    return "連続予約上限 : $suffix";
  }

  String _getTimeSlot() {
    if (vipMemberItem == null) return "利用時間 : 制限なし";
    String timeStr = (vipMemberItem!.timeSlotText ?? "制限なし")
        .replaceAll("時間帯: ", "").replaceAll("時間帯：", "").trim();
    if (timeStr == "00:00~23:59" || timeStr == "00:00～23:59" || (timeStr.contains("23:59") && timeStr.contains("00:00"))) {
      return "利用時間 : 終日";
    }
    return "利用時間 : $timeStr";
  }

  String _getDayText() {
    if (vipMemberItem == null) return "利用日 : 制限なし";
    String dayStr = (vipMemberItem!.dayText ?? "制限なし")
        .replaceAll("曜日: ", "").replaceAll("曜日：", "").trim();
    if (dayStr == "全日") {
      return "利用日 : 毎日";
    }
    return "利用日 : $dayStr";
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.sp, vertical: 5.0.sp),
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.colorScheme.onBackground,
          borderRadius: BorderRadius.circular(10.0.sp),
        ),
        padding: EdgeInsets.all(10.0.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${vipMemberItem?.nameCodeMember}",
              style: appTheme.textTheme.headlineMedium!.copyWith(
                color: appTheme.colorScheme.surface,
              ),
            ),
            SizedBox(height: 3.0.sp),
            Text(
              _getPlayInMonth(),
              style: appTheme.textTheme.bodyMedium!.copyWith(
                color: appTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.0.sp),
            Text(
              _getPlayInDay(),
              style: appTheme.textTheme.bodyMedium!.copyWith(
                color: appTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.0.sp),
            Text(
              _getConsecutive(),
              style: appTheme.textTheme.bodyMedium!.copyWith(
                color: appTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.0.sp),
            Text(
              _getTimeSlot(),
              style: appTheme.textTheme.bodyMedium!.copyWith(
                color: appTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.0.sp),
            Text(
              _getDayText(),
              style: appTheme.textTheme.bodyMedium!.copyWith(
                color: appTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'price'.tr,
                        style: appTheme.textTheme.bodySmall!.copyWith(
                          color: appTheme.colorScheme.outline,
                          fontSize: 11.0.sp,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${vipMemberItem?.amount?.round().toStringFormatCurrency()}",
                        style: appTheme.textTheme.titleMedium!.copyWith(
                          color: appTheme.colorScheme.surface,
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                PressableText(
                  "register".tr,
                  style: appTheme.textTheme.headlineSmall!.copyWith(
                    color: appTheme.colorScheme.onSecondary,
                  ),
                  backgroundColor: appTheme.colorScheme.secondary,
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5.0.sp),
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.0.sp,
                    vertical: 6.0.sp,
                  ),
                  onPress: () => onRegisterPressed?.call(),
                  enabled: availableRegister,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
