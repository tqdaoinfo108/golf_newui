import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/model/auth.dart';
import 'package:golf_uiv2/model/auth_body.dart';
import 'package:golf_uiv2/model/get_payment_key_request.dart';
import 'package:golf_uiv2/model/page_result.dart';
import 'package:golf_uiv2/model/payment_item.dart';
import 'package:golf_uiv2/model/payment_key_response.dart';
import 'package:golf_uiv2/model/shop_model.dart';
import 'package:golf_uiv2/model/shop_vip_memeber.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/support.dart';

class BuyVipListController extends GetxController
    with StateMixin<List<ShopVipMember>> {
  ShopItemModel? shop;
  late int _page;
  late int _limit;
  late bool _lstVipMemberStillBusy;
  late bool _availableLoadMore;

  List<ShopVipMember> _lstVipMembers = <ShopVipMember>[];
  List<ShopVipMember> get lstVipMembers => _lstVipMembers;

  final _total = 0.obs;
  int get total => _total.value;

  final _registerVipMemberStillBusy = false.obs;
  bool get registerVipMemberStillBusy => _registerVipMemberStillBusy.value;

  @override
  void onInit() {
    super.onInit();
    _page = 0;
    _limit = DEFAUTL_LIMIT;
    _lstVipMembers = [];

    shop = Get.arguments;

    change(null, status: RxStatus.loading());
    getAllShopVipMember();
  }

  getAllShopVipMember() async {
    _lstVipMemberStillBusy = true;
    var res = await new GolfApi().getAllShopVipMember(
      shop!.shopID,
      _page,
      _limit,
    );

    if (res != null) {
      _total.value = res.total ?? 0;
      _lstVipMembers.addAll(res.data ?? []);

      change(_lstVipMembers, status: RxStatus.success());
    } else {
      if (res!.getException == null) {
        res.setException(
          ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR,
          ),
        );
      }
      change(
        res.data,
        status: RxStatus.error(res.getException!.getErrorMessage()),
      );
    }
    _lstVipMemberStillBusy = false;
  }

  requestLoadMore() async {
    if (!_lstVipMemberStillBusy) {
      _availableLoadMore = _lstVipMembers.length < total;
      if (_availableLoadMore) {
        _page++;
        await getAllShopVipMember();
      }
    }
  }

  Future<bool> registerVipMember(
    ShopVipMember vipMember,
    PaymentKeyResponse? paymentInfo,
    int status,
    int isRenew,
  ) async {
    /// Call Service
    final _result = await GolfApi().addPaymentVipMember(
      AuthBody<Map<String, dynamic>>()
        ..setAuth(Auth())
        ..setData({
          'CodeMemberID': vipMember.codeMemberId,
          'Order_ID': paymentInfo?.oderId ?? "",
          'PaymentCode': paymentInfo?.paymentKey ?? "",
          'Status': status,
          'IsRenew': isRenew,
        }, dataToJson: (data) => data),
    );

    /// Handle result
    if (_result.data != null) {
      return true;
    } else {
      if (_result.getException == null) {
        _result.setException(
          ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR,
          ),
        );
      }

      /// Show Error
      SupportUtils.showToast(
        'register_vip_member_fail'.tr,
        type: ToastType.ERROR,
      );

      return false;
    }
  }

  Future<bool> letsPayment(ShopVipMember vipMember, {int isRenew = 1}) async {
    _registerVipMemberStillBusy.value = true;
    final request = GetPaymentKeyRequest(
      capture: true,
      shopID: vipMember.shopId,
      additionalMessage:
          "${vipMember.nameCodeMember} (" +
          (vipMember.typeCodeMember == VipMemberType.UNLIMIT
              ? "unlimited".tr
              : "${vipMember.numberPlayInMonth} ${"turns".tr.toLowerCase()}") +
          " / ${"month".tr.toLowerCase()})",
      items: [
        PaymentItem(
          id: vipMember.codeMemberId,
          name: vipMember.nameCodeMember,
          price: vipMember.amount!.round(),
          quantity: 1,
        ),
      ],
    );

    /// Lets payment this booking
    var result = await Get.toNamed(AppRoutes.PYAYMENT, arguments: request);

    /// Payment completed
    if (result != null) {
      /// Payment successful
      if ((result as PageResult).resultCode == PageResultCode.OK) {
        var isPayment = await registerVipMember(
          vipMember,
          (result as PageResult<PaymentKeyResponse>).data,
          1,
          isRenew,
        );
        if (isPayment) {
          _registerVipMemberStillBusy.value = false;
          return true;
        }
      }

      /// Payment Failure
      if (result.resultCode == PageResultCode.FAIL) {
        SupportUtils.showToast('payment_failure'.tr, type: ToastType.ERROR);
        await registerVipMember(vipMember, null, -1, isRenew);
      }
    }

    _registerVipMemberStillBusy.value = false;
    return false;
  }
}
