import 'package:get/get.dart';
import 'package:golf_uiv2/screens/booking_detail/booking_detail_controller.dart';

class BookingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingDetailController>(() => BookingDetailController());
  }
}
