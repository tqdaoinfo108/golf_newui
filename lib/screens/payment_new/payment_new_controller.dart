import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/get_payment_key_request.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../model/application_error.dart';
import '../../model/auth.dart';
import '../../model/auth_body.dart';
import '../../model/payment_key_response.dart';
import '../../services/golf_api.dart';
import '../../utils/constants.dart';
import 'masked_text_controller.dart';

class PaymentdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(() => PaymentController());
  }
}

class PaymentController extends GetxController
    with StateMixin<PaymentKeyResponse> {
  GetPaymentKeyRequest? _paymentRequest;
  RxBool isLoading = false.obs;

  //
  RxString cardNumber = "".obs;
  RxString expiryDate = "".obs;
  RxString cardHolderName = "".obs;
  RxString cvvCode = "".obs;
  RxBool isCvvFocused = false.obs;
  bool useGlassMorphism = false;

    final MaskedTextController cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController cardHolderNameController =
      TextEditingController();
  final TextEditingController cvvCodeController =
      MaskedTextController(mask: '0000');

  @override
  void onInit() {
    super.onInit();
    _paymentRequest = Get.arguments;
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    cardNumber.value = creditCardModel!.cardNumber;
    expiryDate.value = creditCardModel.expiryDate;
    cardHolderName.value = TiengViet.parse(creditCardModel.cardHolderName).toUpperCase();
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
    refresh();
  }

  Future<PaymentKeyResponse?> getPaymentKey() async {
    _paymentRequest!.cardNumber = cardNumber.value;
    _paymentRequest!.cardExpire = expiryDate.value;
    _paymentRequest!.securityCode = cvvCode.value;
    _paymentRequest!.holderName = cardHolderName.value;
    isLoading.value = true;
    /// Call Service
    final _result =
        await GolfApi().getPaymentKey(AuthBody<Map<String, dynamic>>()
          ..setAuth(Auth())
          ..setData(_paymentRequest!.toJson(), dataToJson: (data) => data));

    isLoading.value = false;
    /// Handle result
    if (_result.data != null) {
      return _result.data?..shopID = _result.shopID;
    } else {
      if (_result.getException == null) {
        _result.setException(ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
      }

      change(_result.data,
          status: RxStatus.error(_result.getException!.getErrorMessage()));
    }
    return null;
  }
}
