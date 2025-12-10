import 'package:get/get.dart';
import 'package:golf_uiv2/model/base_respose.dart';
import 'package:golf_uiv2/model/notification.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:loadmore/loadmore.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}

class NotificationController extends GetxController {
  int? total = 0;
  var page = 1;
  var litmit = 10;
  var userId = SupportUtils.prefs.getInt(USER_ID);

  final _isLoading = true.obs;
  bool get isLoading => this._isLoading.value;
  set isLoading(bool value) => this._isLoading.value = value;

  final RxList<NotificationItemModel> _lstNotification =
      <NotificationItemModel>[].obs;
  List<NotificationItemModel> get lstNotification => this._lstNotification;
  set lstNotification(List<NotificationItemModel> value) =>
      this._lstNotification.value = value;

  @override
  void onInit() {
    super.onInit();
    page = 1;
    lstNotification = <NotificationItemModel>[];
    getListNotication();
  }

  Future<bool> getListNotication() async {
    print('📄 Loading notifications - Page: $page');

    try {
      final result = await GolfApi().getNotification(userId, page, litmit);

      if (result != null && result.data != null && result.data!.isNotEmpty) {
        total = result.total;

        // Add to list instead of replacing
        if (page == 1) {
          // First page - replace
          lstNotification = result.data!;
          print('✅ First page loaded: ${result.data!.length} items');
        } else {
          // Load more - append
          lstNotification.addAll(result.data!);
          print(
            '✅ Page $page loaded: ${result.data!.length} more items. Total: ${lstNotification.length}',
          );
        }

        // Increment page for next load
        page++;

        isLoading = false;
        update();
        return true;
      } else {
        print('⚠️ No data returned from API');
        isLoading = false;
        update();
        return false;
      }
    } catch (e) {
      print('❌ Error loading notifications: $e');
      isLoading = false;
      update();
      return false;
    }
  }

  // Future<bool> getistNotificationMore() async {
  //   print("onLoadMore");
  //   await Future.delayed(Duration(seconds: 0, milliseconds: 100));
  //   // load();
  //   return true;
  // }

  Future<bool> clearAllNotification() async {
    isLoading = true;
    update();

    BaseResponse result = await GolfApi().clearNotification(userId);

    if (result.data.toString().contains('true')) {
      // Reset everything
      page = 1;
      total = 0;
      lstNotification.clear();

      // Reload first page
      await getListNotication();

      print('✅ All notifications cleared');
      return true;
    }

    isLoading = false;
    update();
    return false;
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
