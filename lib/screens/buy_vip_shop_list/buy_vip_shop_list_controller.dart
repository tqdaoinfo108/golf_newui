import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/model/shop_model.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:location/location.dart';

class BuyVipShopListController extends GetxController
    with StateMixin<List<ShopItemModel>> {
  double? _lat = -1;
  double? _log = -1;
  int? userId;
  String querySearch = "";

  @override
  void onInit() {
    super.onInit();
    userId = SupportUtils.prefs.getInt(USER_ID);

    change(null, status: RxStatus.loading());
    searchShopForPayVip("");
  }

  void searchShopForPayVip(String query) async {
    await _detectLocation();
    var res = await new GolfApi()
        .getShop(_log! > 0 ? _log : 0, _lat! > 0 ? _lat : 0, 10, query, userId);

    if (res != null) {
      change(
          res.data?.where((shop) => shop.countMemberCode! > 0).toList() ?? [],
          status: RxStatus.success());
    } else {
      if (res?.getException == null) {
        res?.setException(ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
      }
      change(res?.data,
          status: RxStatus.error(res?.getException?.getErrorMessage()));
    }
  }

  void changeFavorite(int? shopId) {
    GolfApi().changeFavorite(shopId, userId).then((value) => {
          if (value.data!) {searchShopForPayVip("")}
        });
  }

  void changeQuerySearch(String query) {
    this.querySearch = query;
    requestRefresh();
  }

  void requestRefresh() {
    change(null, status: RxStatus.loading());
    searchShopForPayVip(querySearch);
  }

  Future<void> _detectLocation() async {
    var _location = Location();
    var _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    var _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    var _res = await _location.getLocation();
    _lat = _res.latitude;
    _log = _res.longitude;
  }
}
