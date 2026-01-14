import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/decision_option.dart';
import 'package:golf_uiv2/model/page_result.dart';
import 'package:golf_uiv2/model/shop_vip_memeber.dart';
import 'package:golf_uiv2/screens/buy_vip_list/widgets/buy_vip_list_item.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/app_listview.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:sizer/sizer.dart';

import '../../utils/color.dart';
import 'buy_vip_list_controller.dart';

class BuyVipListScreen extends GetView<BuyVipListController> {
  const BuyVipListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: GolfColor.GolfPrimaryColor,
      appBar: ApplicationAppBar(context, "back".tr),
      body: Container(
        decoration: BoxDecoration(
          color: appTheme.colorScheme.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0.sp,
                    horizontal: 15.0.sp,
                  ),
                  child: Obx(
                    () => Text(
                      "${'list_vip_memeber'.tr} (${controller.total})",
                      style: appTheme.textTheme.headlineSmall,
                    ),
                  ),
                ),
                Flexible(
                  child: controller.obx(
                    (lstVipMembers) =>
                        (lstVipMembers?.isEmpty ?? true)
                            ? _buildEmptyList(appTheme)
                            : AppListView(
                              itemCount: lstVipMembers!.length,
                              itemBuilder:
                                  (context, index) => BuyVipListItem(
                                    vipMemberItem: lstVipMembers[index],
                                    shopName: lstVipMembers[index].description,
                                    // availableRegister:
                                    //     !(lstVipMembers[index].typeCodeMember ==
                                    //             VipMemberType.UNLIMIT &&
                                    //         (controller.shop!.isMember ?? false)),
                                    onRegisterPressed:
                                        () => _pressedRegister(
                                          lstVipMembers[index],
                                        ),
                                  ),
                              onLoadMore: () => controller.requestLoadMore(),
                            ),
                    onLoading: _buildLoadingIndicator(appTheme),
                    onError: (error) {
                      SupportUtils.showToast(error, type: ToastType.ERROR);
                      return Container();
                    },
                  ),
                ),
              ],
            ),
            Obx(
              () =>
                  controller.registerVipMemberStillBusy
                      ? Container(
                        color: Colors.transparent,
                        child: _buildLoadingIndicator(appTheme),
                      )
                      : Container(),
            ),
          ],
        ),
      ),
    );
  }

  _pressedRegister(ShopVipMember vipMember) {
    if (vipMember.typeCodeMember != VipMemberType.LIMIT) {
      // unlimit -> isRenew có thể = 1
      SupportUtils.showDecisionDialog(
        "membership_purchase_notice".tr,
        lstOptions: [
          DecisionOption(
            'cancel'.tr,
            type: DecisionOptionType.WARNING,
            onDecisionPressed: null,
          ),
          (vipMember.isAllowReccuring ?? true)
              ? DecisionOption(
                'agree_and_continue'.tr,
                isImportant: true,
                onDecisionPressed:
                    () => _paymentAndRegister(vipMember, isRenew: 1),
              )
              : DecisionOption(
                'agree_and_continue'.tr,
                isImportant: true,
                onDecisionPressed:
                    () => _paymentAndRegister(vipMember, isRenew: 0),
              ),
        ],
      );
    } else {
      SupportUtils.showDecisionDialog(
        "limit_would_you_like_to_purchase".tr,
        lstOptions: [
          DecisionOption(
            'cancel'.tr,
            type: DecisionOptionType.WARNING,
            onDecisionPressed: null,
          ),
          DecisionOption(
            'agree_and_continue'.tr,
            isImportant: true,
            onDecisionPressed: () => _paymentAndRegister(vipMember, isRenew: 0),
          ), // k phải unlimit -> isRenew = 0
        ],
      );
    }
  }

  _paymentAndRegister(ShopVipMember vipMember, {int isRenew = 1}) {
    if (isRenew == 1) {
      _paymentAndRegisterAutoRenew(vipMember);
      return;
    }

    controller.letsPayment(vipMember, isRenew: 0).then((res) {
      if (res) _completeRegisterVipMember();
    });
  }

  _paymentAndRegisterAutoRenew(ShopVipMember vipMember) {
    controller.letsPayment(vipMember).then((res) {
      if (res) _completeRegisterVipMember();
    });
  }

  Widget _buildEmptyList(ThemeData appTheme) => Container(
    child: Center(
      child: Text(
        "not_have_vip_member".tr,
        style: appTheme.textTheme.titleSmall?.copyWith(
          color: appTheme.colorScheme.surface,
        ),
      ),
    ),
  );

  Widget _buildLoadingIndicator(ThemeData appTheme) => Container(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    ),
  );

  _completeRegisterVipMember() =>
      Get.back(result: PageResult(resultCode: PageResultCode.OK));
}
