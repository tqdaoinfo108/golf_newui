import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/screens/booking/booking_controller.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/booking_item.dart';
import 'package:golf_uiv2/widgets/pressable_icon.dart';
import 'package:golf_uiv2/widgets/text_field.dart';
import 'package:sizer/sizer.dart';

class BookingScreen extends StatelessWidget {
  BookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return GetBuilder<BookingController>(
        init: BookingController(),
        initState: (_) {
          Get.find<BookingController>().getShopByLocation();
        },
        builder: (controller) {
          return Container(
              child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2.0.h),
                    alignment: Alignment.center,
                    child: Text(
                      "explore".tr,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 15),
                    alignment: Alignment.centerRight,
                    child: PressableIcon(
                      Icons.favorite_outline,
                      size: 5.0.w,
                      padding: EdgeInsets.all(6),
                      color: Colors.white,
                      borderSide: BorderSide.none,
                      backgroundColor: Colors.white.withOpacity(.25),
                      borderRadius: BorderRadius.circular(18),
                      onPress: () => Get.toNamed(AppRoutes.FAVORITE_SHOP)!
                          .then((value) => controller.getShopByKeySearch("")),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding:
                      EdgeInsets.only(top: 2.0.w, left: 2.0.w, right: 2.0.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6.0.w),
                        topRight: Radius.circular(6.0.w)),
                    color: theme.colorScheme.background,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.0.sp),
                      Container(
                        // search
                        child: Row(
                          children: [
                            Expanded(
                                child: searchTextFieldView(theme, controller)),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: controller.getShopByLocation,
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color:
                                        theme.colorScheme.backgroundCardColor,
                                  ),
                                  child: Icon(
                                    Icons.refresh_outlined,
                                    color: theme.colorScheme.iconColor,
                                    size: 5.0.w,
                                  )), // đổi icon theo y/c anh toàn
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('nearest_list'.tr, style: theme.textTheme.headlineSmall),
                      SizedBox(height: 10),
                      Flexible(
                        child: controller.obx(
                          (lstShops) => (lstShops?.isEmpty ?? true)
                              ? _buildEmptyList(theme)
                              : ListView.builder(
                                  itemCount: lstShops?.length ?? 0,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return shopItemView(
                                      theme,
                                      controller.lstShop[index],
                                      onItemPressed: () => Get.toNamed(
                                        AppRoutes.BOOKING_CREATE,
                                        arguments: controller.lstShop[index],
                                      )!.then((value) =>
                                          controller.getShopByKeySearch("")),
                                      onFavoriteChanged: (val) =>
                                          controller.changeFavorite(
                                              controller.lstShop[index].shopID),
                                    );
                                  },
                                ),
                          onLoading: _buildLoadingIndicator(theme),
                          onError: (error) {
                            SupportUtils.showToast(error,
                                type: ToastType.ERROR);
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
        });
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
