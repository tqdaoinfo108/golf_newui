import 'package:get/get.dart';
import 'booking_create_uservip_controller.dart';

class BookingCreateUserVipBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingCreateUserVipController>(() => BookingCreateUserVipController());
  }
}
