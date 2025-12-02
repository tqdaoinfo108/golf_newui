import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/screens/dashboard/dashboard_controller.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/widgets/dashboard_item.dart';
import 'package:sizer/sizer.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';

class DashboardScreen extends GetView<DashboardController> {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return GetBuilder<DashboardController>(
      initState: (_state) {
        controller.page = 1;
        // Delay to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.getListBooking();
          controller.updateUserInfo();
        });
      },
      builder: (_) {
        return Obx(
          () => DefaultTabController(
            length: 3,
            initialIndex: controller.pageNumber.value,
            child: Column(
              children: [
                // Header
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF241D59), Color(0xFF232F7C)],
                      stops: [0.0, 0.5225],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: kToolbarHeight,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      children: [
                        Obx(
                          () =>
                              ((controller.userInfo!.imagesPaths ?? "").isEmpty)
                                  ? ClipOval(
                                    child: Image.asset(
                                      'assets/images/user.png',
                                      width: 45.0.sp,
                                      height: 45.0.sp,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : ClipOval(
                                    child: Image.network(
                                      '$GOLF_CORE_API_URL$USER_AVATAR_PATH${controller.userInfo!.imagesPaths}',
                                      width: 45.0.sp,
                                      height: 45.0.sp,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                        ),
                        SizedBox(width: 2.0.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                controller.userInfo!.fullName ?? "",
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (controller.userInfo!.isUserManager ?? false)
                          Image.asset(
                            "assets/icons/person_vip.png",
                            width: 48,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        IconButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.NOTIFICATIONS);
                          },
                          icon: Icon(Icons.notifications, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                // TabBar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF232F7C), Colors.white],
                      stops: [
                        0.5,
                        0.5,
                      ], // 50% trên là primary, 50% dưới là trắng
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TabBar(
                      indicatorColor: GolfColor.GolfSubColor,
                      unselectedLabelColor: Colors.grey,
                      labelColor: GolfColor.GolfSubColor,
                      onTap: (value) async => await controller.onTab(value),
                      tabs: [
                        SizedBox(
                          height: 45.0.sp,
                          child: Tab(
                            child: rowTabbar(theme, Icons.check, 'success'.tr),
                          ),
                        ),
                        SizedBox(
                          height: 45.0.sp,
                          child: Tab(
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                rowTabbar(
                                  theme,
                                  Icons.payment,
                                  "wait_payment".tr,
                                ),
                                Obx(
                                  () => _buildBadge(
                                    theme,
                                    controller.totalWaitPayment,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 45.0.sp,
                          child: Tab(
                            child: rowTabbar(
                              theme,
                              Icons.cancel_outlined,
                              'canceled'.tr,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // TabBarView
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildBookingList(context, theme, controller, 0),
                      _buildBookingList(context, theme, controller, 1),
                      _buildBookingList(context, theme, controller, 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingList(
    BuildContext context,
    ThemeData theme,
    DashboardController controller,
    int tabIndex,
  ) {
    // Bạn có thể lọc danh sách theo tabIndex nếu cần
    if (controller.isLoadingBookingHistory && !controller.isLoadingMore) {
      return Center(child: CircularProgressIndicator());
    }
    if (controller.lstDateBooking.isEmpty) {
      return Center(
        child: Text(
          'not_found_booking'.tr,
          style: theme.textTheme.headlineLarge,
        ),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            controller.totalLoadedBooking < controller.totalBooking! &&
            !controller.isLoadingBookingHistory) {
          controller.isLoadingMore = true;
          controller.getListBooking();
        }
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 16),
        itemCount:
            controller.totalLoadedBooking < controller.totalBooking!
                ? controller.lstDateBooking.length + 1
                : controller.lstDateBooking.length,
        itemBuilder: (BuildContext context, int index) {
          return index == controller.lstDateBooking.length
              ? SizedBox(
                height: controller.isLoadingBookingHistory ? 60 : 0,
                child: Center(child: CircularProgressIndicator()),
              )
              : Column(
                children: [
                  bookingListItemView(
                    theme,
                    controller.mapMyBooking[controller.lstDateBooking[index]]!,
                    (_bookingItem) {
                      Get.toNamed(
                        AppRoutes.BOOKING_DETAIL,
                        arguments: _bookingItem.bookID,
                      )!.then((value) {
                        controller.page = 1;
                        controller.getListBooking();
                      });
                    },
                  ),
                  if (index == controller.lstDateBooking.length - 1)
                    SizedBox(height: 120),
                ],
              );
        },
      ),
    );
  }

  _buildBadge(ThemeData appthem, int badgeNum) {
    return badgeNum > 0
        ? Container(
          margin: EdgeInsets.only(left: 20.0.sp, bottom: 5.0.sp),
          padding: EdgeInsets.symmetric(horizontal: 4.0.sp, vertical: 1.0.sp),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5.0.sp),
          ),
          child: Text(
            "$badgeNum",
            style: appthem.textTheme.titleSmall!.copyWith(
              fontSize: 8.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
        : Container();
  }
}

Widget rowTabbar(ThemeData theme, IconData icon, String text) {
  return Wrap(
    spacing: 0.5.w,
    runSpacing: 0.5.w,
    direction: Axis.horizontal,
    children: [
      Center(
        child: Icon(icon, color: theme.colorScheme.iconColor, size: 4.0.w),
      ),
      SizedBox(width: 1.0.w),
      Center(
        child: AutoSizeText(
          text,
          wrapWords: true,
          maxLines: 1,
          style: theme.textTheme.titleSmall,
        ),
      ),
    ],
  );
}
