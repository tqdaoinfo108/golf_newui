import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/screens/booking/booking_screen.dart';
import 'package:golf_uiv2/screens/dashboard/dashboard_screen.dart';
import 'package:golf_uiv2/screens/settings/settings_screen.dart';
import '../../utils/color.dart';
import '../booking/booking_nav.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(
            index: controller.tabIndex,
            children: [
              DashboardScreen(),
              // NotificationScreen(),
              BookingNav(),
              // BookingScreen(),
              SettingsScreen(),
            ],
          ),
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xffC0C0C0), width: 1),
              ),
            ),
            margin: const EdgeInsets.only(top: 20),
            height: 62,
            width: 62,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 0,
              onPressed: () => controller.changeTabIndex(1),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 0, color: Colors.transparent),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset("assets/images/add.png", color: GolfColor
                  .GolfSubColor, width: 48, height: 48),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xffC0C0C0), width: 1),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: appTheme.colorScheme.onBackground,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: controller.changeTabIndex,
              currentIndex: controller.tabIndex,
              selectedItemColor: GolfColor.GolfPrimaryColor,
              unselectedItemColor: GolfColor.GolfSubColor,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 35),
                  label: 'home'.tr,
                ),
                BottomNavigationBarItem(
                  icon: SizedBox.shrink(), // Placeholder để giữ vị trí cho nút giữa
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person, size: 35),
                  label: 'setting'.tr,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
