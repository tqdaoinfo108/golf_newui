import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/screens/booking/booking_screen.dart';
import 'package:golf_uiv2/screens/dashboard/dashboard_screen.dart';
import 'package:golf_uiv2/screens/notifications/notifications_screen.dart';
import 'package:golf_uiv2/screens/settings/settings_screen.dart';
import 'package:sizer/sizer.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: PageView(
              // index: controller.tabIndex,
              physics: new NeverScrollableScrollPhysics(), // disable swipe
              controller: controller.pageController,
              onPageChanged: controller.changePageIndex,
              children: [
                DashboardScreen(),
                BookingScreen(),
                NotificationScreen(),
                SettingsScreen(),
              ],
            ),
          ),
          extendBody: true,
          backgroundColor: appTheme.colorScheme.primary,
          bottomNavigationBar: Container(
            color: context.theme.scaffoldBackgroundColor,
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: BottomNavigationBar(
                backgroundColor: appTheme.colorScheme.onBackground,
                showSelectedLabels: true,
                showUnselectedLabels: false,
                onTap: controller.changeTabIndex,
                currentIndex: controller.tabIndex,
                selectedItemColor: appTheme.colorScheme.primary,
                unselectedItemColor: appTheme.colorScheme.surface,
                selectedFontSize: 11.0.sp,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      size: 7.0.w,
                    ),
                    label: 'home'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      size: 7.0.w,
                    ),
                    label: 'explore'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.notifications,
                      size: 7.0.w,
                    ),
                    label: 'notification'.tr,
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person,
                        size: 7.0.w,
                      ),
                      label: 'setting'.tr)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
