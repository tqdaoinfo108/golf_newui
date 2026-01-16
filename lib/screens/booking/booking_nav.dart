import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/screens/booking/booking_screen.dart';
import 'package:golf_uiv2/screens/booking_create/booking_create_screen.dart';
import 'package:golf_uiv2/utils/keys.dart';

import '../../model/shop_model.dart';
import '../../utils/support.dart';
import '../booking_create/booking_create_controller.dart';
import '../booking_create_uservip/booking_create_uservip_controller.dart';
import '../booking_create_uservip/booking_create_uservip_screen.dart';

class BookingNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(1),
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.BOOKING_CREATE) {
          if (SupportUtils.prefs.getInt(USER_TYPE_ID) == 4 || SupportUtils.prefs.getInt(USER_TYPE_ID) == 2) {
            Get.put(BookingCreateUserVipController());
          } else {
            Get.put(BookingCreateController());
          }
          return GetPageRoute(
            settings: settings,
            page:
                () =>
                    SupportUtils.prefs.getInt(USER_TYPE_ID) == 4 || SupportUtils.prefs.getInt(USER_TYPE_ID) == 2
                        ? BookingCreateUserVipScreen(
                          settings.arguments as ShopItemModel,
                        )
                        : BookingCreateScreen(
                          settings.arguments as ShopItemModel,
                        ),
          );
        } else {
          return GetPageRoute(settings: settings, page: () => BookingScreen());
        }
      },
    );
  }
}
