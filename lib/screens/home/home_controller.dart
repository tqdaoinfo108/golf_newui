import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/screens/dashboard/dashboard_controller.dart';

import '../booking_create/booking_create_controller.dart';

class HomeController extends GetxController {
  var tabIndex = 0;

  @override
  void onInit() {
    super.onInit();
  }

  void changeTabIndex(int index) {
    tabIndex = index;
    Get.find<DashboardController>().justUpdateWaitPaymentTotal();
    if (index == 1) {
      Get.lazyPut(()=>BookingCreateController());
      // Get.toNamed("/test", id: 1);
      // Get.delete<BookingCreateController>();
    }
    update();
  }

  void changePageIndex(int index) {
    tabIndex = index;
    update();
  }
}
