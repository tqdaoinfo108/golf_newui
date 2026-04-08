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
              vipMemberItem?.numberPlayInMonthText ??
                  "月あたり最大利用可能枠: 制限なし",
              style: appTheme.textTheme.bodyMedium!.copyWith(
                color: appTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.0.sp),
            Text(
              vipMemberItem?.numberPlayInDayText ??
                  "1日あたり最大予約枠数: 制限なし",
              style: appTheme.textTheme.bodyMedium!.copyWith(
                color: appTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.0.sp),
            Text(
              vipMemberItem?.numberConsecutiveText ??
                  "最大連続予約数: 制限なし",
              style: appTheme.textTheme.bodyMedium!.copyWith(
                color: appTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.0.sp),
            Text(
              vipMemberItem?.timeSlotText ?? "時間帯: 制限なし",
              style: appTheme.textTheme.bodyMedium!.copyWith(
                color: appTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.0.sp),
            Text(
              vipMemberItem?.dayText ?? "曜日: 制限なし",
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
