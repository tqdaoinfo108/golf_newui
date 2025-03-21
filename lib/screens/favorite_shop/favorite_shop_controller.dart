import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/model/shop_model.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';

class FavoriteShopController extends GetxController
    with StateMixin<List<ShopItemModel>> {
  int? userId;
  late bool _lstFavoriteShopStillBusy;
  late bool _availableLoadMore;
  late int _page;
  late int _limit;

  List<ShopItemModel> _lstFavoriteShop = <ShopItemModel>[];
  List<ShopItemModel> get lstFavoriteShop => _lstFavoriteShop;

  final _total = 0.obs;
  int get total => _total.value;

  @override
  void onInit() {
    super.onInit();
    userId = SupportUtils.prefs.getInt(USER_ID);
    _page = 0;
    _limit = DEFAUTL_LIMIT;
    _lstFavoriteShop = [];

    change(null, status: RxStatus.loading());
    getFavoriteShop();
  }

  requestLoadMore() async {
    if (!_lstFavoriteShopStillBusy) {
      _availableLoadMore = _lstFavoriteShop.length < total;
      if (_availableLoadMore) {
        _page++;
        await getFavoriteShop();
      }
    }
  }

  requestRefresh() {
    _page = 0;
    _lstFavoriteShop = [];
    change(null, status: RxStatus.loading());
    getFavoriteShop();
  }

  getFavoriteShop() async {
    _lstFavoriteShopStillBusy = true;
    var res = await new GolfApi().getListShopFavorite(_page, _limit, userId);

    if (res.data != null) {
      _total.value = res.total!;
      _lstFavoriteShop.addAll(res.data!);

      change(_lstFavoriteShop, status: RxStatus.success());
    } else {
      if (res.getException == null) {
        res.setException(ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
      }
      change(res.data,
          status: RxStatus.error(res.getException!.getErrorMessage()));
    }
    _lstFavoriteShopStillBusy = false;
  }

  void changeFavorite(int? shopId) {
    GolfApi().changeFavorite(shopId, userId).then((value) => {
          if (value.data!) {requestRefresh()}
        });
  }
}
