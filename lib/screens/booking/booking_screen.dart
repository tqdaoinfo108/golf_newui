import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/screens/booking/booking_controller.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';
import 'package:golf_uiv2/utils/color.dart';
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
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Stack(
              children: [
                Container(
                  height: 25.h,
                  width: 100.w,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: kToolbarHeight),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF241D59), Color(0xFF232F7C)],
                      stops: [0.0, 0.5225],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Text(
                      "explore".tr,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.0.h,
                    horizontal: 15,
                  ),
                  alignment: Alignment.centerRight,
                  child: PressableIcon(
                    Icons.favorite_outline,
                    size: 5.0.w,
                    padding: EdgeInsets.all(6),
                    color: Colors.white,
                    borderSide: BorderSide.none,
                    backgroundColor: Colors.white.withOpacity(.25),
                    borderRadius: BorderRadius.circular(18),
                    onPress:
                        () => Get.toNamed(
                          AppRoutes.FAVORITE_SHOP,
                        )!.then((value) => controller.getShopByKeySearch("")),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: Offset(0, -40),
              child: Container(
                margin: EdgeInsets.only(top: 25.h),
                height: 75.h,
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.5),
                      blurRadius: 7, // Độ mờ của bóng
                      offset: Offset(0, 3), // Vị trí bóng (x, y)
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: Color(0xffF1F1FA),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -20),
                      child: Row(
                        children: [
                          Expanded(
                            child: searchTextFieldView(theme, controller),
                          ),
                          // SizedBox(width: 10),
                          // InkWell(
                          //   onTap: controller.getShopByLocation,
                          //   child: Container(
                          //     alignment: Alignment.center,
                          //     padding: EdgeInsets.all(16),
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(10),
                          //       ),
                          //       color: theme.colorScheme.backgroundCardColor,
                          //     ),
                          //     child: Icon(
                          //       Icons.refresh_outlined,
                          //       color: theme.colorScheme.iconColor,
                          //       size: 5.0.w,
                          //     ),
                          //   ), // đổi icon theo y/c anh toàn
                          // ),
                        ],
                      ),
                    ),
                    Text(
                      'nearest_list'.tr,
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: GolfColor.GolfSubColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: controller.obx(
                        (lstShops) =>
                            (lstShops?.isEmpty ?? true)
                                ? _buildEmptyList(theme)
                                : ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  itemCount: lstShops?.length ?? 0,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        shopItemView(
                                          theme,
                                          controller.lstShop[index],
                                          onItemPressed:
                                              () => Get.toNamed(
                                                AppRoutes.BOOKING_CREATE,
                                                arguments:
                                                    controller.lstShop[index],
                                                id: 1,
                                              )!.then(
                                                (value) => controller
                                                    .getShopByKeySearch(""),
                                              ),
                                          onFavoriteChanged:
                                              (val) => controller.changeFavorite(
                                                controller.lstShop[index].shopID,
                                              ),
                                        ),
                                        if(index == lstShops!.length -1)
                                          SizedBox(height: 80)
                                      ],
                                    );
                                  },
                                ),
                        onLoading: _buildLoadingIndicator(theme),
                        onError: (error) {
                          SupportUtils.showToast(error, type: ToastType.ERROR);
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyList(ThemeData appTheme) => Center(
    child: Text(
      "not_found_shop".tr,
      style: appTheme.textTheme.titleSmall?.copyWith(
        color: appTheme.colorScheme.surface,
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
