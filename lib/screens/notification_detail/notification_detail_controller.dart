import 'package:get/get.dart';
import 'package:golf_uiv2/model/notification.dart';

class NotificationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationDetailController>(() => NotificationDetailController());
  }
}

class NotificationDetailController extends GetxController {
  final Rx<NotificationItemModel?> _notification = Rx<NotificationItemModel?>(null);
  NotificationItemModel? get notification => _notification.value;
  set notification(NotificationItemModel? value) => _notification.value = value;

  @override
  void onInit() {
    super.onInit();
    
    // Get notification from arguments
    if (Get.arguments != null && Get.arguments is NotificationItemModel) {
      notification = Get.arguments as NotificationItemModel;
    }
  }
}
