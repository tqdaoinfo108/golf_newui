import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:golf_uiv2/model/decision_option.dart';
import 'package:golf_uiv2/model/user_vip_member.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/pressable.dart';
import 'package:golf_uiv2/widgets/pressable_text.dart';
import 'package:sizer/sizer.dart';

class MyVipListItem extends StatelessWidget {
  const MyVipListItem({
    Key? key,
    this.vipMemberItem,
    this.itemPressed,
    this.autoRenewChanged,
    this.cancelPressed,
    this.enable = true,
  }) : super(key: key);

  final UserVipMember? vipMemberItem;
  final void Function()? itemPressed;
  final void Function(bool val)? autoRenewChanged;
  final void Function()? cancelPressed;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final _autoRenew = (vipMemberItem!.isRenew == 1).obs;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.sp, vertical: 5.0.sp),
      child: Pressable(
        child: Container(
          decoration: BoxDecoration(
            color: enable ? appTheme.colorScheme.primary : Colors.grey,
            borderRadius: BorderRadius.circular(10.0.sp),
          ),
          padding: EdgeInsets.fromLTRB(10.0.sp, 20.0.sp, 10.0.sp, 10.0.sp),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo_background.png",
                    fit: BoxFit.fitHeight,
                    height: 84.0.sp,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${vipMemberItem!.shopName}",
                    style: appTheme.textTheme.headlineMedium!.copyWith(
                      color: appTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${vipMemberItem!.nameCodeMember}",
                    style: appTheme.textTheme.headlineSmall!.copyWith(
                      color: appTheme.colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 45.0.sp),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: appTheme.colorScheme.onPrimary,
                        size: 18.0.sp,
                      ),
                      SizedBox(width: 5.0.sp),
                      Expanded(
                        child: Text(
                          "${vipMemberItem!.shopAddress}",
                          style: appTheme.textTheme.bodyMedium!.copyWith(
                            color: appTheme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0.sp),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: appTheme.colorScheme.onPrimary,
                        size: 18.0.sp,
                      ),
                      SizedBox(width: 5.0.sp),
                      vipMemberItem!.typeLimit == VipMemberType.UNLIMIT
                          ? Obx(
                            () => Text(
                              _autoRenew.value
                                  ? "${"next_renewal_date".tr}: ${vipMemberItem!.toDate!.toStringFormatSimpleDateUTC()}"
                                  : "${"expiration_date".tr}: ${vipMemberItem!.toDate!.toStringFormatSimpleDateUTC()}",
                              style: appTheme.textTheme.bodyMedium!.copyWith(
                                color: appTheme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                          : Text(
                            "${"from_date".tr.replaceFirst('...', "${vipMemberItem!.getLimitMemberFromDate()!.toStringFormatSimpleDateUTC()}")}" +
                                " -- " +
                                "${"to_date".tr.replaceFirst('...', "${vipMemberItem!.getLimitMemberToDate()!.toStringFormatSimpleDateUTC()}")}",
                            style: appTheme.textTheme.bodyMedium!.copyWith(
                              color: appTheme.colorScheme.onPrimary,
                            ),
                          ),
                    ],
                  ),
                  SizedBox(height: 5.0.sp),
                  Row(
                    children: [
                      Icon(
                        Icons.play_arrow_outlined,
                        color: appTheme.colorScheme.onPrimary,
                        size: 18.0.sp,
                      ),
                      SizedBox(width: 5.0.sp),
                      Text(
                        (vipMemberItem!.typeLimit == VipMemberType.UNLIMIT
                            ? "unlimited_turns".tr
                            : ("${"available_turns".tr}: " +
                                "${vipMemberItem?.remainPlay} / ${vipMemberItem?.sumBuyPlay}")),
                        style: appTheme.textTheme.bodyMedium!.copyWith(
                          color: appTheme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PressableText(
                        "cancel".tr,
                        backgroundColor: appTheme.colorScheme.error.withOpacity(
                          .85,
                        ),
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15.0.sp),
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0.sp,
                          horizontal: 10.0.sp,
                        ),
                        style: appTheme.textTheme.titleSmall!.copyWith(
                          color: appTheme.colorScheme.onError,
                          fontSize: 9.0.sp,
                        ),
                        onPress: () {
                          SupportUtils.showDecisionDialog(
                            "${"membership_cancel_notice".tr}",
                            lstOptions: [
                              DecisionOption(
                                'withdraw_membership'.tr,
                                onDecisionPressed: () {
                                  cancelPressed?.call();
                                },
                              ),
                              DecisionOption(
                                'cancel'.tr,
                                isImportant: true,
                                type: DecisionOptionType.DENIED,
                                onDecisionPressed: null,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        onPress: () => itemPressed?.call(),
      ),
    );
  }
}
