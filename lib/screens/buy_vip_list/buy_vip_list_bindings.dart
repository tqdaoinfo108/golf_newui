import 'package:get/get.dart';
import 'buy_vip_list_controller.dart';

class BuyVipListBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyVipListController>(() => BuyVipListController());
  }
}
