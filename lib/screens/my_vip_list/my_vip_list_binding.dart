import 'package:get/get.dart';
import 'package:golf_uiv2/screens/my_vip_list/my_vip_list_controller.dart';

class MyVipListBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyVipListController>(() => MyVipListController());
  }
}
