import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/screens/dashboard/dashboard_controller.dart';

class HomeController extends GetxController {
  var tabIndex = 0;
  var pageController = PageController();

  @override
  void onInit() {
    super.onInit();
  }

  void changeTabIndex(int index) {
    tabIndex = index;
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 50),
      curve: Curves.easeOut,
    );
    Get.find<DashboardController>().justUpdateWaitPaymentTotal();
    print("page :" + index.toString());
    update();
  }

  void changePageIndex(int index) {
    tabIndex = index;
    update();
  }
}
