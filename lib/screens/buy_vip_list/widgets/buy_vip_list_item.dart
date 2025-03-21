import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:golf_uiv2/model/shop_vip_memeber.dart';
import 'package:golf_uiv2/utils/constants.dart';
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
              style: appTheme.textTheme.headlineSmall!
                  .copyWith(color: appTheme.colorScheme.surface),
            ),
            SizedBox(height: 5.0.sp),
            Text(
              "$shopName",
              style: appTheme.textTheme.titleSmall!
                  .copyWith(color: appTheme.colorScheme.onSurface),
            ),
            SizedBox(height: 5.0.sp),
            Text("${vipMemberItem?.description}",
                style: appTheme.textTheme.headlineSmall!
                    .copyWith(color: appTheme.colorScheme.onSurface)),
            SizedBox(height: 5.0.sp),
            Row(
              children: [
                Icon(
                  Icons.play_arrow_outlined,
                  color: appTheme.colorScheme.surface,
                  size: 18.0.sp,
                ),
                SizedBox(width: 5.0.sp),
                Text(
                  (vipMemberItem!.typeCodeMember == VipMemberType.UNLIMIT
                      ? "${"unlimited".tr} / ${"month".tr.toLowerCase()}"
                      : "${vipMemberItem?.numberPlayInMonth} ${"turns".tr.toLowerCase()}"),
                  style: appTheme.textTheme.titleSmall!
                      .copyWith(color: appTheme.colorScheme.onSurface),
                ),
              ],
            ),
            SizedBox(height: 3.0.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.8.sp),
                      child: Text("¥",
                          style: appTheme.textTheme.titleSmall!.copyWith(
                            color: appTheme.colorScheme.surface,
                            fontSize: 16.0.sp,
                          )),
                    ),
                    SizedBox(width: 5.0.sp),
                    Text(
                      "${vipMemberItem?.amount?.round().toStringFormatCurrency()}",
                      style: appTheme.textTheme.titleSmall!
                          .copyWith(color: appTheme.colorScheme.onSurface),
                    ),
                  ],
                ),
                PressableText(
                  "register".tr,
                  style: appTheme.textTheme.headlineSmall!
                      .copyWith(color: appTheme.colorScheme.onSecondary),
                  backgroundColor: appTheme.colorScheme.secondary,
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5.0.sp),
                  padding: EdgeInsets.symmetric(
                      horizontal: 25.0.sp, vertical: 6.0.sp),
                  onPress: () => onRegisterPressed?.call(),
                  enabled: availableRegister,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
