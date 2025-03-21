import 'package:get/get.dart';
import 'booking_create_controller.dart';

class BookingCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingCreateController>(() => BookingCreateController());
  }
}
