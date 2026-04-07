import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/model/transaction.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';

class TransactionHistoryController extends GetxController
    with StateMixin<List<Transaction>> {
  List<Transaction> _lstTransactions = <Transaction>[];
  List<Transaction> get lstTransactions => _lstTransactions;

  late int _page;
  late int _limit;
  late int _rawTotal;
  late bool _lstTransactionsStillBusy;
  late bool _availableLoadMore;
  int? userId;

  final _total = 0.obs;
  int get total => _total.value;

  final Rx<DateTime> _fromDateFilter = DateTime.now().startOfMonth().obs;
  DateTime get fromDateFilter => _fromDateFilter.value;
  set fromDateFilter(DateTime value) => _fromDateFilter.value = value;

  final Rx<DateTime> _toDateFilter = DateTime.now().endOfDay().obs;
  DateTime get toDateFilter => _toDateFilter.value;
  set toDateFilter(DateTime value) => _toDateFilter.value = value;

  @override
  void onInit() {
    super.onInit();
    _page = 0;
    _limit = DEFAUTL_LIMIT;
    _rawTotal = 0;
    _lstTransactions = [];

    userId = SupportUtils.prefs.getInt(USER_ID);

    change(null, status: RxStatus.loading());
    getTransactions();
  }

  requestLoadMore() async {
    if (!_lstTransactionsStillBusy) {
      _availableLoadMore = ((_page + 1) * _limit) < _rawTotal;
      if (_availableLoadMore) {
        _page++;
        await getTransactions();
      }
    }
  }

  requestRefresh() {
    _page = 0;
    _rawTotal = 0;
    _lstTransactions = [];
    change(null, status: RxStatus.loading());
    getTransactions();
  }

  getTransactions() async {
    _lstTransactionsStillBusy = true;
    var res = await new GolfApi().getTransactionHistory(
      userId,
      _page,
      _limit,
      fromDateFilter.startOfDay().millisecondsSinceEpoch ~/ 1000,
      toDateFilter.endOfDay().millisecondsSinceEpoch ~/ 1000,
    );

    if (res != null) {
      _rawTotal = res.total ?? 0;

      final filteredTransactions =
          (res.data ?? <Transaction>[])
              .where(_isMembershipPurchaseTransaction)
              .toList();

      _lstTransactions.addAll(filteredTransactions);
      _total.value = _lstTransactions.length;

      change(_lstTransactions, status: RxStatus.success());
    } else {
      if (res!.getException == null) {
        res.setException(ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
      }
      change(res.data,
          status: RxStatus.error(res.getException!.getErrorMessage()));
    }
    _lstTransactionsStillBusy = false;
  }

  bool _isMembershipPurchaseTransaction(Transaction transaction) {
    return transaction.typePayment == PaymentType.REGISTER_VIP_MEMBER ||
        transaction.typePayment == PaymentType.AUTO_RENEW_VIP_MEMBER;
  }

  Future<void> deleteTransaction(Transaction item) async {
    try {
      final res = await GolfApi().deletePaymentHistory(item.payId!, userId!);

      if (res.data.toString().contains('true')) {
        _lstTransactions.removeWhere((t) => t.payId == item.payId);
        _total.value = _total.value - 1;
        change(_lstTransactions, status: RxStatus.success());
        SupportUtils.showToast("deleted".tr, type: ToastType.SUCCESSFUL);
      } else {
        SupportUtils.showToast("delete_failed".tr, type: ToastType.ERROR);
      }
    } catch (e) {
      SupportUtils.showToast("system_error".tr, type: ToastType.ERROR);
    }
  }
}
