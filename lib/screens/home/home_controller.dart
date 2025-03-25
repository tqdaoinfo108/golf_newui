import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/screens/dashboard/dashboard_controller.dart';

class HomeController extends GetxController {
  var tabIndex = 0;

  @override
  void onInit() {
    super.onInit();
  }

  void changeTabIndex(int index) {
    tabIndex = index;
    Get.find<DashboardController>().justUpdateWaitPaymentTotal();
    print("page :" + index.toString());
    update();
  }

  void changePageIndex(int index) {
    tabIndex = index;
    update();
  }

}
