import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/model/booking.dart';
import 'package:golf_uiv2/model/my_booking.dart';
import 'package:golf_uiv2/model/user.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:loadmore/loadmore.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}

class DashboardController extends GetxController {
  var page = 1;
  var limit = 15;
  String? errorMessage = '';
  // var mapMyBooking = Map<int, MyBooking>();
  int? totalBooking = -1;
  var totalLoadedBooking = 0;
  String? avatar = "";
  var status = 1;
  int? userId = 0;

  RxInt pageNumber = 0.obs;

  final RxMap<int?, MyBooking> _mapMyBooking = Map<int, MyBooking>().obs;
  Map<int?, MyBooking> get mapMyBooking => this._mapMyBooking;
  set mapMyBooking(Map<int?, MyBooking> _mapMyBooking) =>
      this._mapMyBooking.value = _mapMyBooking;

  final _isLoadingBookingHistory = false.obs;
  bool get isLoadingBookingHistory => this._isLoadingBookingHistory.value;
  set isLoadingBookingHistory(bool value) =>
      this._isLoadingBookingHistory.value = value;

  final _isLoadingMore = false.obs;
  bool get isLoadingMore => this._isLoadingMore.value;
  set isLoadingMore(bool value) => this._isLoadingMore.value = value;

  final RxList<int?> _lstDateBooking = <int?>[].obs;
  List<int?> get lstDateBooking => this._lstDateBooking;
  set lstDateBooking(List<int?> value) => this._lstDateBooking.value = value;

  final _totalWaitPayment = 0.obs;
  int get totalWaitPayment => this._totalWaitPayment.value;

  final Rx<User?> _userInfo = User().obs;
  User? get userInfo => this._userInfo.value;

  @override
  void onInit() {
    super.onInit();
    avatar = SupportUtils.prefs.getString(USER_AVATAR);
    userId = SupportUtils.prefs.getInt(USER_ID);

    justUpdateWaitPaymentTotal();

    _userInfo.value = User(
      userID: SupportUtils.prefs.getInt(USER_ID),
      uUserID: SupportUtils.prefs.getString(USERNAME),
      fullName: SupportUtils.prefs.getString(USER_FULLNAME),
      email: SupportUtils.prefs.getString(USER_EMAIL),
      imagesPaths: SupportUtils.prefs.getString(USER_AVATAR),
      providerUserID: SupportUtils.prefs.getString(USER_PROVIDDER_ID),
      confirmEmail: SupportUtils.prefs.getInt(VERIFIED_EMAIL),
    );
  }

  void justUpdateWaitPaymentTotal() {
    GolfApi().getLstHistoryBooking(userId, 0, 1, 1).then((res) {
      if (res.total! >= 0) {
        _totalWaitPayment.value = res.total!;
      }
    });
  }

  Future<bool> updateUserInfo() async {
    final _ueserInfoResult = await GolfApi().getUserInfo();

    /// Handle Register result
    if (_ueserInfoResult.data != null) {
      _userInfo.value = _ueserInfoResult.data;

      /// Save User Information to SharePreference
      SupportUtils.prefs.setString(USERNAME, userInfo!.uUserID!);
      SupportUtils.prefs.setString(USER_FULLNAME, userInfo!.fullName!);
      SupportUtils.prefs.setString(USER_EMAIL, userInfo!.email!);
      SupportUtils.prefs.setInt(USER_ID, userInfo!.userID!);
      SupportUtils.prefs.setString(USER_PHONE, userInfo!.phone!);
      SupportUtils.prefs.setString(USER_AVATAR, userInfo!.imagesPaths!);
      SupportUtils.prefs.setInt(VERIFIED_EMAIL, userInfo!.confirmEmail!);
      return true;
    } else {
      if (_ueserInfoResult.getException == null) {
        _ueserInfoResult.setException(ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
      }
      return false;
    }
  }

  Future<bool> getListBooking() async {
    isLoadingBookingHistory = true;

    /// Return now if this page has loaded or this list has been loaded complete
    /// If you want update total, please load page 1 again
    var _currPageLoaded = ((totalLoadedBooking - 1) ~/ limit) + 1;
    if (totalBooking != -1 &&
        page != 1 &&
        (_currPageLoaded == page || totalLoadedBooking >= totalBooking!)) {
      return true;
    }

    /// Call Service
    final _result =
        await GolfApi().getLstHistoryBooking(userId, status, page, limit);

    /// Handle result
    if (_result.data != null || _result.total! >= 0) {
      totalBooking = _result.total;
      if (status == 0) {
        _totalWaitPayment.value = _result.total!;
      }

      /// Reset lst history booking if this is loading first page
      if (page == 1) {
        _mapMyBooking.clear();
        _lstDateBooking.clear();
        totalLoadedBooking = 0;
        _mapMyBooking.refresh();
        _lstDateBooking.refresh();
      }

      /// Merge all booking has been gotten to Map
      if (_result.data != null) {
        for (var _bookingItem in _result.data!) {
          var _bookingItemSorted = sortBookingAvailablePlayTime(_bookingItem);
          var _datePlayInMilis = _bookingItemSorted.datePlay;
          _mapMyBooking[_datePlayInMilis] ??= MyBooking(date: _datePlayInMilis);
          _mapMyBooking[_datePlayInMilis]!.lstBooking ??= [];
          _mapMyBooking[_datePlayInMilis]!.lstBooking!.add(_bookingItemSorted);
        }

        /// Update List Date Booking
        lstDateBooking = _mapMyBooking.keys.toList()
          ..sort((a, b) => compareBookingDatePlay(a!, b));
        page++;
        totalLoadedBooking += _result.data!.length;
      }

      isLoadingBookingHistory = false;
      isLoadingMore = false;
      return true;
    } else {
      if (_result.getException == null) {
        _result.setException(ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
      }
      errorMessage = _result.getException?.getErrorMessage();
      isLoadingBookingHistory = false;
      isLoadingMore = false;

      /// Show Error
      SupportUtils.showToast(errorMessage, type: ToastType.ERROR);

      return false;
    }
  }

  Future<void> onTab(int page) async {
    switch (page) {
      case 0:
        status = 1;
        break;
      case 1:
        status = 0;
        break;
      case 2:
        status = -1;
        break;
      default:
        status = 1;
    }
    print("page status: " + page.toString());
    this.pageNumber.value = page;
    this.isLoadingBookingHistory = true;
    this.page = 1;
    this.totalBooking = 0;
    this.totalLoadedBooking = 0;
    await getListBooking();
    _mapMyBooking.refresh();
  }

  Booking sortBookingAvailablePlayTime(Booking bookingItem) {
    return bookingItem
      ..blocks!.sort((a, b) {
        var _currMilis = DateTime.now().millisecondsSinceEpoch;
        var _aStrartRange = _currMilis - a.rangeStart!;
        var _bStrartRange = _currMilis - b.rangeStart!;

        if (_aStrartRange == 0) return -1;
        if (_bStrartRange == 0) return 1;
        if (_aStrartRange < 0 && _bStrartRange > 0) {
          return -1;
        }
        if (_bStrartRange < 0 && _aStrartRange > 0) {
          return 1;
        }
        if (_aStrartRange > 0 && _bStrartRange > 0) {
          return _aStrartRange.compareTo(_bStrartRange);
        }
        if (_aStrartRange < 0 && _bStrartRange < 0) {
          return _bStrartRange.compareTo(_aStrartRange);
        }
        return 0;
      });
  }

  /// Compare rule:
  /// If both A and B is greater than or equal today => Just sort ascending
  /// The other cases => Just sort descending
  int compareBookingDatePlay(int a, int? b) {
    final currentMili = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).millisecondsSinceEpoch;

    if (a >= currentMili && b! >= currentMili) {
      return a.compareTo(b);
    } else {
      return b!.compareTo(a);
    }
  }

  String buildStringLoadMore(LoadMoreStatus status) {
    String text = '';
    // switch (status) {
    //   case LoadMoreStatus.fail:
    //     text = "加载失败，请点击重试";
    //     break;
    //   case LoadMoreStatus.idle:
    //     text = "等待加载更多";
    //     break;
    //   case LoadMoreStatus.loading:
    //     text = "加载中，请稍候...";
    //     break;
    //   case LoadMoreStatus.nomore:
    //     text = "到底了，别扯了";
    //     break;
    //   default:
    //     text = "";
    // }
    return text;
  }
}
