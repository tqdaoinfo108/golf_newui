import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/model/auth.dart';
import 'package:golf_uiv2/model/auth_body.dart';
import 'package:golf_uiv2/model/base_respose.dart';
import 'package:golf_uiv2/model/user_vip_member.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';

class MyVipListController extends GetxController
    with StateMixin<List<UserVipMember>> {
  int? userId;

  List<UserVipMember>? _lstVipMembers = <UserVipMember>[];
  List<UserVipMember>? get lstVipMembers => _lstVipMembers;

  final _total = 0.obs;
  int get total => _total.value;

  @override
  void onInit() {
    super.onInit();
    userId = SupportUtils.prefs.getInt(USER_ID);

    change(null, status: RxStatus.loading());
    getUserVipMember();
  }

  getUserVipMember() async {
    var res = await new GolfApi().getUserVipMember(userId);

    if (res != null) {
      _total.value = res.total!;
      _lstVipMembers = res.data;

      change(res.data, status: RxStatus.success());
    } else {
      if (res!.getException == null) {
        res.setException(ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
      }
      change(res.data,
          status: RxStatus.error(res.getException!.getErrorMessage()));
    }
  }

  Future<void> cancelMember(UserVipMember vipMember) async {
    var _result = BaseResponse<bool>();

    /// Call Service
    _result = await GolfApi().cancelVipMember(AuthBody<Map<String, dynamic>>()
      ..setAuth(Auth())
      ..setData({
        'userCodeMemberID': vipMember.userCodeMemberId,
      }, dataToJson: (data) => data));

    /// Handle result
    if (_result.data == null || !_result.data!) {
      if (_result.getException == null) {
        _result.setException(ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
      }

      /// Show Error
      SupportUtils.showToast(_result.getException!.getErrorMessage(),
          type: ToastType.ERROR);
    } else {
      /// Success - refresh list
      SupportUtils.showToast('success'.tr, type: ToastType.SUCCESSFUL);
      getUserVipMember();
    }
  }

  Future<void> updateRenew(UserVipMember vipMember, bool isAutoRenew) async {
    var _result = BaseResponse<bool>();

    /// Call Service
    _result = await GolfApi()
        .updateVipMemberAutoRenew(AuthBody<Map<String, dynamic>>()
          ..setAuth(Auth())
          ..setData({
            'userCodeMemberID': vipMember.userCodeMemberId,
            'IsRenew': isAutoRenew ? 1 : 0,
          }, dataToJson: (data) => data));

    /// Handle result
    if (_result.data == null && !_result.data!) {
      if (_result.getException == null) {
        _result.setException(ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
      }

      /// Show Error
      SupportUtils.showToast(_result.getException!.getErrorMessage(),
          type: ToastType.ERROR);
    }
  }
}
