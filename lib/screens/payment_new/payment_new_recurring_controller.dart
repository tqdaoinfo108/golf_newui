import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../model/application_error.dart';
import '../../model/auth.dart';
import '../../model/auth_body.dart';
import '../../model/check_card_authorize_request.dart';
import '../../model/check_card_authorize_response.dart';
import '../../model/page_result.dart';
import '../../router/app_routers.dart';
import '../../services/golf_api.dart';
import '../../utils/constants.dart';
import '../../utils/support.dart';
import 'masked_text_controller.dart';

class PaymentRecurringBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentRecurringController>(() => PaymentRecurringController());
  }
}

class PaymentRecurringController extends GetxController
    with StateMixin<CheckCardAuthorizeResponse> {
  int? codeMemberID;
  RxBool isLoading = false.obs;

  //
  RxString cardNumber = "".obs;
  RxString expiryDate = "".obs;
  RxString cardHolderName = "".obs;
  RxString cvvCode = "".obs;
  RxBool isCvvFocused = false.obs;
  bool useGlassMorphism = false;

  RxString cvvErrorText = "".obs;
  RxBool isAgreedToTerms = false.obs;

  final MaskedTextController cardNumberController = MaskedTextController(
    mask: '0000 0000 0000 0000',
  );
  final TextEditingController expiryDateController = MaskedTextController(
    mask: '00/00',
  );
  final TextEditingController cardHolderNameController =
      TextEditingController();
  final TextEditingController cvvCodeController = MaskedTextController(
    mask: '0000',
  );

  final cvvGlobalKey = GlobalKey<FormFieldState<String>>(
    debugLabel: 'cvvCodeKey',
  );

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    codeMemberID = Get.arguments as int?;
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    cardNumber.value = creditCardModel!.cardNumber;
    expiryDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName.replaceAll(
      RegExp(r'[^a-zA-Z\s]'),
      '',
    );
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
    refresh();
  }

  void onValidate() async {
    final isValid = cvvGlobalKey.currentState?.validate() ?? false;
    final errorText = cvvGlobalKey.currentState?.errorText;
    cvvErrorText.value = errorText ?? "";

    if (formKey.currentState!.validate()) {
      var rs = await checkCardAuthorize();
      if (rs != null) {
        // Check if authorization is successful
        if (rs.mstatus == "success" && rs.authStartUrl != null) {
          // Navigate to web view with the authStartUrl
          var result = await Get.toNamed(AppRoutes.PYAYMENT_WEB, arguments: rs);
          if (result as bool) {
            Get.back(
              result: PageResult(resultCode: PageResultCode.OK, data: rs),
            );
          } else {
            Get.back(result: PageResult(resultCode: PageResultCode.FAIL));
          }
        } else {
          SupportUtils.showToast(
            rs.merrMsg ?? 'authorization_failed'.tr,
            type: ToastType.ERROR,
          );
          Get.back(result: PageResult(resultCode: PageResultCode.FAIL));
        }
      } else {
        SupportUtils.showToast('server_error'.tr, type: ToastType.ERROR);
      }
    }
  }

  Future<CheckCardAuthorizeResponse?> checkCardAuthorize() async {
    final request = CheckCardAuthorizeRequest(
      cardNumber: cardNumber.value.replaceAll(' ', ''),
      cardExpire: expiryDate.value,
      securityCode: cvvCode.value,
      cardholderName: cardHolderName.value,
      codeMemberID: codeMemberID,
    );

    isLoading.value = true;

    /// Call Service
    final _result = await GolfApi().checkCardAuthorize(
      AuthBody<Map<String, dynamic>>()
        ..setAuth(Auth())
        ..setData(request.toJson(), dataToJson: (data) => data),
    );

    isLoading.value = false;

    /// Handle result
    if (_result.data != null) {
      // Add card information to the response
      return _result.data?.copyWith(
        cardNumber: cardNumber.value.replaceAll(' ', ''),
        cardExpire: expiryDate.value,
        securityCode: cvvCode.value,
        cardholderName: cardHolderName.value,
      );
    } else {
      if (_result.getException == null) {
        _result.setException(
          ApplicationError.withCode(
            ApplicationErrorCode.UNKNOW_APPLICATION_ERROR,
          ),
        );
      }

      change(
        _result.data,
        status: RxStatus.error(_result.getException!.getErrorMessage()),
      );
    }
    return null;
  }
}
