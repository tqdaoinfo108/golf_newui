import 'package:get/get.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/screens/booking/booking_controller.dart';
import 'package:golf_uiv2/screens/booking_detail/booking_detail_binding.dart';
import 'package:golf_uiv2/screens/booking_detail/booking_detail_screen.dart';
import 'package:golf_uiv2/screens/buy_vip_list/buy_vip_list_bindings.dart';
import 'package:golf_uiv2/screens/buy_vip_list/buy_vip_list_screen.dart';
import 'package:golf_uiv2/screens/buy_vip_shop_list/buy_vip_shop_list_bindings.dart';
import 'package:golf_uiv2/screens/buy_vip_shop_list/buy_vip_shop_list_screen.dart';
import 'package:golf_uiv2/screens/change_password/change_password_controller.dart';
import 'package:golf_uiv2/screens/change_password/change_password_screen.dart';
import 'package:golf_uiv2/screens/dashboard/dashboard_controller.dart';
import 'package:golf_uiv2/screens/favorite_shop/favorite_shop_bindings.dart';
import 'package:golf_uiv2/screens/favorite_shop/favorite_shop_screen.dart';
import 'package:golf_uiv2/screens/forgot_password/forgot_password_controller.dart';
import 'package:golf_uiv2/screens/forgot_password/forgot_password_screen.dart';
import 'package:golf_uiv2/screens/home/home_binding.dart';
import 'package:golf_uiv2/screens/home/home_screen.dart';
import 'package:golf_uiv2/screens/login/login_controller.dart';
import 'package:golf_uiv2/screens/login/login_screen.dart';
import 'package:golf_uiv2/screens/my_vip_list/my_vip_list_binding.dart';
import 'package:golf_uiv2/screens/my_vip_list/my_vip_list_screen.dart';
import 'package:golf_uiv2/screens/notifications/notifications_controller.dart';
import 'package:golf_uiv2/screens/notification_detail/notification_detail_controller.dart';
import 'package:golf_uiv2/screens/notification_detail/notification_detail_screen.dart';
import 'package:golf_uiv2/screens/payment_new_web/payment_new_web_controller.dart';
import 'package:golf_uiv2/screens/profile/profile_binding.dart';
import 'package:golf_uiv2/screens/profile/profile_screen.dart';
import 'package:golf_uiv2/screens/settings/settings_controller.dart';
import 'package:golf_uiv2/screens/settings/settings_screen.dart';
import 'package:golf_uiv2/screens/sign_up/sign_up_controller.dart';
import 'package:golf_uiv2/screens/sign_up/sign_up_screen.dart';
import 'package:golf_uiv2/screens/terms_of_use/terms_of_use_controller.dart';
import 'package:golf_uiv2/screens/terms_of_use/terms_of_use_screen.dart';
import 'package:golf_uiv2/screens/transaction_history/transaction_history_bindings.dart';
import 'package:golf_uiv2/screens/transaction_history/transaction_history_screen.dart';

import '../screens/booking_create/booking_create_binding.dart';
import '../screens/booking_create/booking_create_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/payment_new/payment_new_controller.dart';
import '../screens/payment_new/payment_new_screen.dart';
import '../screens/payment_new/payment_new_recurring_controller.dart';
import '../screens/payment_new/payment_new_recurring_screen.dart';
import '../screens/payment_new_web/payment_new_web_screen.dart';

class AppScreens {
  static var list = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeScreen(),
      bindings: [
        HomeBinding(),
        DashboardBinding(),
        BookingBinding(),
        NotificationBinding(),
        SettingBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.BOOKING_CREATE,
      page: () => BookingCreateScreen(),
      binding: BookingCreateBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGN_UP,
      page: () => SignUpScreen(),
      binding: SignUpBinding(),
    ),

    GetPage(
      name: AppRoutes.BOOKING_DETAIL,
      page: () => BookingDetailScreen(),
      binding: BookingDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.PYAYMENT,
      page: () => PaymentScreen(),
      binding: PaymentdBinding(),
    ),
    GetPage(
      name: AppRoutes.PYAYMENT_WEB,
      page: () => PaymentWebScreen(),
      binding: PaymentWebdBinding(),
    ),
    GetPage(
      name: AppRoutes.PYAYMENT_RECURRING,
      page: () => PaymentRecurringScreen(),
      binding: PaymentRecurringBinding(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.CHANGE_PASSWORD,
      page: () => ChangePasswordScreen(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.SETTING,
      page: () => SettingsScreen(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: AppRoutes.BUY_VIP_SHOP_LIST,
      page: () => BuyVipShopListScreen(),
      binding: BuyVipShopListBindings(),
    ),
    GetPage(
      name: AppRoutes.BUY_VIP_LIST,
      page: () => BuyVipListScreen(),
      binding: BuyVipListBindings(),
    ),
    GetPage(
      name: AppRoutes.MY_VIP_LIST,
      page: () => MyVipListScreen(),
      binding: MyVipListBindings(),
    ),
    GetPage(
      name: AppRoutes.TRANSACTION_HISTORY,
      page: () => TransactionHistoryScreen(),
      binding: TransactionHistoryBindings(),
    ),
    GetPage(
      name: AppRoutes.FAVORITE_SHOP,
      page: () => FavoriteShopScreen(),
      binding: FavoriteShopBindings(),
    ),
    GetPage(
      name: AppRoutes.TERMS_OF_USE,
      page: () => TermsOfUseScreen(),
      binding: TermsOfUseScreenBindings(),
    ),
    GetPage(
      name: AppRoutes.NOTIFICATIONS,
      page: () => NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: AppRoutes.NOTIFICATION_DETAIL,
      page: () => NotificationDetailScreen(),
      binding: NotificationDetailBinding(),
    ),
  ];
}
