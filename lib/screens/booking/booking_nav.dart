import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/screens/booking/booking_screen.dart';
import 'package:golf_uiv2/screens/booking_create/booking_create_screen.dart';

import '../../model/shop_model.dart';
import '../booking_create/booking_create_controller.dart';

class BookingNav extends StatelessWidget {
  const BookingNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(1),
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.BOOKING_CREATE) {
          Get.put(BookingCreateController());
          return GetPageRoute(
            settings: settings,
            page: () =>  BookingCreateScreen(),
          );
        } else {
          return GetPageRoute(
            settings: settings,
            page: () => BookingScreen(),
          );
        }
      },
    );
  }
}
