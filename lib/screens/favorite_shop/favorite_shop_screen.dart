import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/screens/favorite_shop/favorite_shop_controller.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/app_listview.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:golf_uiv2/widgets/booking_item.dart';
import 'package:sizer/sizer.dart';

class FavoriteShopScreen extends GetView<FavoriteShopController> {
  const FavoriteShopScreen({Key? key}) : super(key: key);

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
            SizedBox(height: 20.0.sp),
            Flexible(
              child: controller.obx(
                (lstFavoriteShop) => (lstFavoriteShop?.isEmpty ?? true)
                    ? _buildEmptyList(appTheme)
                    : AppListView(
                        itemCount: lstFavoriteShop!.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0.sp),
                          child: shopItemView(
                            appTheme,
                            lstFavoriteShop[index],
                            onFavoriteChanged: (val) => controller
                                .changeFavorite(lstFavoriteShop[index].shopID),
                            onItemPressed: () => Get.toNamed(
                                    AppRoutes.BOOKING_CREATE,
                                    arguments: lstFavoriteShop[index])!
                                .then((value) => controller.requestRefresh()),
                          ),
                        ),
                        onLoadMore: () => controller.requestLoadMore(),
                        onRefresh: () => controller.requestRefresh(),
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
}
