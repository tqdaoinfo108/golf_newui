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
            length: 1,
            initialIndex: 0,
            child: Column(
              children: [
                // Header
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1F2354), Color(0xFF283A8B)],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(28),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 12,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () =>
                              ((controller.userInfo!.imagesPaths ?? "").isEmpty)
                                  ? ClipOval(
                                    child: Image.asset(
                                      'assets/images/user.png',
                                      width: 42.0.sp,
                                      height: 42.0.sp,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : ClipOval(
                                    child: Image.network(
                                      '$GOLF_CORE_API_URL$USER_AVATAR_PATH${controller.userInfo!.imagesPaths}',
                                      width: 42.0.sp,
                                      height: 42.0.sp,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                        ),
                        SizedBox(width: 3.0.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.userInfo!.fullName ?? "",
                                style: TextStyle(
                                  fontSize: 13.5.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (controller.userInfo!.isUserManager ?? false)
                          Image.asset(
                            "assets/icons/person_vip.png",
                            width: 44,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        SizedBox(width: 2.w),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Material(
                              color: Colors.white.withOpacity(0.12),
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () {
                                  Get.toNamed(AppRoutes.NOTIFICATIONS);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.notifications_none_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                            if (controller.unreadCount > 0)
                              Positioned(
                                right: -2,
                                top: -3,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: const Color(0xFF1F2354),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      controller.unreadCount > 99
                                          ? '99+'
                                          : '${controller.unreadCount}',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 7.5.sp,
                                            fontWeight: FontWeight.w700,
                                            height: 1.1,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // TabBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4FB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE1E5F5)),
                    ),
                    child: TabBar(
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2B376F).withOpacity(0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      unselectedLabelColor: const Color(0xFF8C92B5),
                      labelColor: const Color(0xFF2F3F95),
                      labelPadding: const EdgeInsets.symmetric(vertical: 4),
                      onTap: (_) {},
                      tabs: [
                        SizedBox(
                          height: 32,
                          child: Tab(
                            child: rowTabbar(
                              theme,
                              Icons.check_circle_outline_rounded,
                              'success'.tr,
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 45.0.sp,
                        //   child: Tab(
                        //     child: Stack(
                        //       alignment: AlignmentDirectional.center,
                        //       children: [
                        //         rowTabbar(
                        //           theme,
                        //           Icons.payment,
                        //           "wait_payment".tr,
                        //         ),
                        //         Obx(
                        //           () => _buildBadge(
                        //             theme,
                        //             controller.totalWaitPayment,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 45.0.sp,
                        //   child: Tab(
                        //     child: rowTabbar(
                        //       theme,
                        //       Icons.cancel_outlined,
                        //       'canceled'.tr,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // TabBarView
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildBookingList(context, theme, controller, 0),
                      ),
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
      return const Center(child: CircularProgressIndicator(strokeWidth: 2.6));
    }
    if (controller.lstDateBooking.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_busy_outlined,
              color: const Color(0xFF97A0C6),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              'not_found_booking'.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF6E7699),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
                        controller.forceRefreshFirstPage();
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
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: theme.colorScheme.iconColor, size: 3.8.w),
      SizedBox(width: 0.8.w),
      Flexible(
        child: AutoSizeText(
          text,
          wrapWords: true,
          maxLines: 1,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 10.5.sp,
          ),
          minFontSize: 8,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
