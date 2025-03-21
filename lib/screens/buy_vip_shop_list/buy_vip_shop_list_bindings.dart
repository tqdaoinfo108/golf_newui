import 'package:get/get.dart';
import 'package:golf_uiv2/screens/buy_vip_shop_list/buy_vip_shop_list_controller.dart';

class BuyVipShopListBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyVipShopListController>(() => BuyVipShopListController());
  }
}
