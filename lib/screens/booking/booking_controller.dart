import 'package:get/get.dart';
import 'package:golf_uiv2/model/shop_model.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:location/location.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingController>(() => BookingController());
  }
}

class BookingController extends GetxController
    with StateMixin<List<ShopItemModel>> {
  // List<ShopItemModel> lstShop;
  double? lat;
  double? log;
  late Location location;
  PermissionStatus? _permissionGranted;
  late bool _serviceEnabled;
  int? userId;

  final RxList<ShopItemModel> _lstShop = <ShopItemModel>[].obs;
  List<ShopItemModel> get lstShop => this._lstShop;
  set lstShop(List<ShopItemModel> value) => this._lstShop.value = value;

  String keySearch = "";
  @override
  void onInit() {
    super.onInit();
    lstShop = [];
    lat = 0;
    log = 0;
    location = Location();

    userId = SupportUtils.prefs.getInt(USER_ID);
  }

  void getShop() async {
    if (lstShop.length == 0) {
      change([], status: RxStatus.loading());
    }

    var listValue =
        await new GolfApi().getShop(log, lat, 10, keySearch, userId);

    if (listValue != null && listValue.data != null) {
      lstShop = listValue.data!;
    }
    change(listValue?.data ?? [], status: RxStatus.success());
    update();
  }

  void changeFavorite(int? shopId) {
    GolfApi().changeFavorite(shopId, userId).then((value) => {
          if (value.data!) {getShop()}
        });
  }

  void getShopByLocation() async {
    getShop();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        lat = 0;
        log = 0;
        getShop();
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        getShop();
        return;
      }
    }

    var _location = await location.getLocation();
    lat = _location.latitude;
    log = _location.longitude;
    getShop();
  }

  void getShopByKeySearch(String value) {
    keySearch = value;
    getShop();
  }
}
