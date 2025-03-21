import 'package:get/get.dart';
import 'package:golf_uiv2/screens/favorite_shop/favorite_shop_controller.dart';

class FavoriteShopBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoriteShopController>(() => FavoriteShopController());
  }
}
