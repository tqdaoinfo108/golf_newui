import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/page_result.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/screens/buy_vip_shop_list/buy_vip_shop_list_controller.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:golf_uiv2/widgets/booking_item.dart';
import 'package:golf_uiv2/widgets/search_field.dart';
import 'package:sizer/sizer.dart';

class BuyVipShopListScreen extends GetView<BuyVipShopListController> {
  const BuyVipShopListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colorScheme.onBackground,
      appBar: ApplicationAppBar(context,"back".tr),
      body: Container(
        decoration: BoxDecoration(
          color: appTheme.colorScheme.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0.sp),
            topRight: Radius.circular(30.0.sp),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0.sp),
              child: SearchField(
                onChangedText: (searchKey) {
                  controller.changeQuerySearch(searchKey);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0.sp,
                horizontal: 15.0.sp,
              ),
              child: Text(
                'nearest_list'.tr,
                style: appTheme.textTheme.headlineSmall,
              ),
            ),
            Flexible(
              child: controller.obx(
                (lstShops) => (lstShops?.isEmpty ?? true)
                    ? _buildEmptyList(appTheme)
                    : ListView.builder(
                        itemCount: lstShops?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0.sp),
                            child: shopItemView(
                              appTheme,
                              lstShops![index],
                              onItemPressed: () {
                                Get.toNamed(
                                  AppRoutes.BUY_VIP_LIST,
                                  arguments: lstShops[index],
                                )!
                                    .then(
                                        (res) => _registerVipMemberBacked(res));
                              },
                              enabled: lstShops[index].countMemberCode! > 0,
                              onFavoriteChanged: (val) => controller
                                  .changeFavorite(lstShops[index].shopID),
                            ),
                          );
                        },
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
      ),
    );
  }

  Widget _buildEmptyList(ThemeData appTheme) => Container(
        child: Center(
          child: Text(
            "not_found_shop".tr,
            style: appTheme.textTheme.titleSmall
                ?.copyWith(color: appTheme.colorScheme.surface),
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

  _registerVipMemberBacked(PageResult? result) {
    controller.requestRefresh();
    if (result != null && result.resultCode == PageResultCode.OK) {
      SupportUtils.showToast(
        "register_vip_member_successful".tr,
        type: ToastType.SUCCESSFUL,
      );
    }
  }
}
