import 'package:get/get.dart';
import 'package:golf_uiv2/model/application_error.dart';
import 'package:golf_uiv2/model/auth.dart';
import 'package:golf_uiv2/model/auth_body.dart';
import 'package:golf_uiv2/model/base_respose.dart';
import 'package:golf_uiv2/model/block.dart';
import 'package:golf_uiv2/model/booking.dart';
import 'package:golf_uiv2/model/decision_option.dart';
import 'package:golf_uiv2/model/get_payment_key_request.dart';
import 'package:golf_uiv2/model/page_result.dart';
import 'package:golf_uiv2/model/payment_item.dart';
import 'package:golf_uiv2/model/payment_key_response.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/services/golf_api.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:golf_uiv2/utils/keys.dart';
import 'package:golf_uiv2/utils/support.dart';

class BookingDetailController extends GetxController {
  // Booking curBooking = new Booking();

  final Rx<Booking> _curBooking = Booking().obs;
  Booking get curBooking => this._curBooking.value;
  set curBooking(Booking value) => this._curBooking.value = value;

  final _isLoadingQRCode = false.obs;
  bool get isLoadingQRCode => this._isLoadingQRCode.value;
  set isLoadingQRCode(bool value) => this._isLoadingQRCode.value = value;

  final _qrCodeString = "".obs;
  String get qrCodeString => this._qrCodeString.value;
  set qrCodeString(String value) => this._qrCodeString.value = value;

  final _isLoading = true.obs;
  bool get isLoading => this._isLoading.value;
  set isLoading(bool value) => this._isLoading.value = value;

  int? _bookingID = 0;
  int? _userId = 0;
  String timeZoneName = "";

  @override
  void onInit() {
    super.onInit();
    _userId = SupportUtils.prefs.getInt(USER_ID);
    curBooking = new Booking();
    _bookingID = Get.arguments;
  }

  Future<void> getBookingHistoryDetail() async {
    final result = await GolfApi().getHistoryBookingDetail(_userId, _bookingID);

    if (result != null && result.bookID != null) {
      curBooking = result;
      isLoading = false;
      update();
    }
  }

  int calculateCurrBookingAmount() {
    var _paymentAmount = 0.0;

    for (var block in curBooking.blocks!) {
      _paymentAmount += block.amountAfterDiscount!;
    }
    return _paymentAmount.round();
  }

  Future<bool> getQRCodeString() async {
    var _result = BaseResponse<String?>();
    isLoadingQRCode = true;

    /// Call Service
    _result = await GolfApi().getBookingQRCodeString(
      _userId,
      curBooking.bookID,
    );

    /// Handle result
    if (_result.data != null) {
      qrCodeString = _result.data!;

      isLoadingQRCode = false;
      return true;
    } else {
      if (_result.getException == null) {
        _result.setException(
          ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR,
          ),
        );
      }
      isLoadingQRCode = false;

      /// Show Error
      SupportUtils.showToast(
        _result.getException!.getErrorMessage(),
        type: ToastType.ERROR,
      );

      return false;
    }
  }

  Future<bool> updateBookingStatus(int status) async {
    BaseResponse<String?> _result = BaseResponse<String>();

    /// Call Service
    _result = await GolfApi().updateBookingStatus(curBooking.bookID, status);

    /// Handle result
    if (_result.data != null) {
      curBooking.statusID = status;
      _curBooking.refresh();
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
        _result.getException!.getErrorMessage(),
        type: ToastType.ERROR,
      );

      return false;
    }
  }

  Future<bool> addPayment({PaymentKeyResponse? paymentInfo}) async {
    var _result = BaseResponse<int?>();

    /// Call Service
    _result = await GolfApi().addPayment(
      AuthBody<Map<String, dynamic>>()
        ..setAuth(Auth())
        ..setData({
          'BookID': curBooking.bookID,
          'Amount': calculateCurrBookingAmount(),
          'CardNumber': paymentInfo?.cardNumber ?? "",
          'Order_ID': paymentInfo?.oderId ?? "",
        }, dataToJson: (data) => data),
    );

    /// Handle result
    if (_result.data != null) {
      return await updateBookingStatus(BookingStatus.PAID);
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
        _result.getException!.getErrorMessage(),
        type: ToastType.ERROR,
      );

      return false;
    }
  }

  void cancelBooking() {
    SupportUtils.showDecisionDialog(
      'are_you_sure_cancel_booking'.tr,
      lstOptions: [
        DecisionOption(
          'yes_cancel_it'.tr,
          type: DecisionOptionType.DENIED,
          onDecisionPressed: () {
            if (curBooking.isAvailableCancel()) {
              updateBookingStatus(BookingStatus.CANCELED);
            } else {
              getBookingHistoryDetail();
              SupportUtils.showToast(
                'cannot_cancel_this_booking'.tr,
                type: ToastType.ERROR,
              );
            }
          },
        ),
        DecisionOption('no'.tr, onDecisionPressed: null, isImportant: true),
      ],
    );
  }

  void letsPaymentWithOnlinePayment() async {
    if (await _reCheckPaymentAvailable()) {
      final request = GetPaymentKeyRequest(
        shopID: curBooking.shopID,
        capture: false,
        additionalMessage: "${curBooking.nameShop} (${curBooking.addressShop})",
        items: _getListPaymentItems(),
      );

      /// Lets payment this booking
      var result = await Get.toNamed(AppRoutes.PYAYMENT, arguments: request);

      /// Payment completed
      if (result != null) {
        /// Payment successful
        if ((result as PageResult).resultCode == PageResultCode.OK) {
          var isPayment = await addPayment(
            paymentInfo: (result as PageResult<PaymentKeyResponse>).data,
          );
          if (isPayment) {
            SupportUtils.showToast(
              'payment_success'.tr,
              type: ToastType.SUCCESSFUL,
            );
            await getQRCodeString();
          }
        }

        /// Payment Failure
        if (result.resultCode == PageResultCode.FAIL) {
          SupportUtils.showToast('payment_failure'.tr, type: ToastType.ERROR);
        }
      }
    }
  }

// ko dùng
  void letsPaymentOrther5and6() async {
    if (await _reCheckPaymentAvailable()) {
      final request = GetPaymentKeyRequest(
        shopID: curBooking.shopID,
        capture: false,
        additionalMessage: "${curBooking.nameShop} (${curBooking.addressShop})",
        items: _getListPaymentItems(),
      );

      /// Lets payment this booking
      var result = await Get.toNamed(AppRoutes.PYAYMENT, arguments: request);

      /// Payment completed
      if (result != null) {
        /// Payment successful
        if ((result as PageResult).resultCode == PageResultCode.OK) {
          var isPayment = await addPayment(
            paymentInfo: (result as PageResult<PaymentKeyResponse>).data,
          );
          if (isPayment) {
            SupportUtils.showToast(
              'payment_success'.tr,
              type: ToastType.SUCCESSFUL,
            );
            await getQRCodeString();
          }
        }

        /// Payment Failure
        if (result.resultCode == PageResultCode.FAIL) {
          SupportUtils.showToast('payment_failure'.tr, type: ToastType.ERROR);
        }
      }
    }
  }

  void letsPaymentWithVipMember() async {
    if (await _reCheckPaymentAvailable()) {
      if (curBooking.payment!.typePayment ==
          BookingDetailPaymentType.MEMBER_LIMITED_AND_ONLINE) {
        SupportUtils.showToast(
          "${'payment_failure'.tr}. ${'your_vip_card_is_not_enough_turn'.tr} ${'please_buy_other_card'.tr}",
          type: ToastType.ERROR,
        );
        return;
      }

      var isPayment = await addPayment();
      if (isPayment) {
        SupportUtils.showToast(
          'payment_success'.tr,
          type: ToastType.SUCCESSFUL,
        );
        await getQRCodeString();
      }
    }
  }

  Future<bool> _reCheckPaymentAvailable() async {
    await getBookingHistoryDetail();
    if (curBooking.statusID != BookingStatus.WAITING_PAYMENT) {
      /// This booking has canceled
      SupportUtils.showToast('cancel_booking_by_payment'.tr);
      return false;
    } else {
      // check amount
      if (calculateCurrBookingAmount() <= 0) {
        SupportUtils.showToast('amount_not_valid'.tr, type: ToastType.ERROR);
        return false;
      }

      return true;
    }
  }

  _getListPaymentItems() {
    List<PaymentItem> lstPaymentItems = [];
    var _bookingDiscount = 0;
    var _isPaymentWithLimitedAndOnline =
        curBooking.payment!.typePayment ==
        BookingDetailPaymentType.MEMBER_LIMITED_AND_ONLINE;
    var _priceSortedBlocks = List<Blocks>.from(curBooking.blocks!)
      ..sort((a, b) => a.price!.compareTo(b.price!));
    var _totalBlocksToPay =
        _isPaymentWithLimitedAndOnline
            ? curBooking.payment!.turnVisa!
            : _priceSortedBlocks.length;

    for (var i = 0; i < _totalBlocksToPay; i++) {
      final block = _priceSortedBlocks[i];
      _bookingDiscount += block.discount!.round();

      lstPaymentItems.add(
        PaymentItem(
          id: block.blockID,
          name: block.getNameBlock(),
          price: block.price!.round(),
          quantity: 1,
        ),
      );
    }

    for (var i = _totalBlocksToPay; i < _priceSortedBlocks.length; i++) {
      final block = _priceSortedBlocks[i];

      lstPaymentItems.add(
        PaymentItem(
          id: block.blockID,
          name: block.getNameBlock(),
          price: 0,
          quantity: 1,
        ),
      );
    }

    if (_bookingDiscount > 0) {
      lstPaymentItems.add(
        PaymentItem(
          id: DateTime.now().millisecondsSinceEpoch,
          name: 'Discount',
          price: _bookingDiscount,
          quantity: 1,
        ),
      );
    }

    return lstPaymentItems;
  }
}
