import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/decision_option.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../model/page_result.dart';
import '../../widgets/button_default.dart';
import 'credit_card_form_custom.dart';
import 'payment_new_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    var border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 0),
    );

    return WillPopScope(
      onWillPop: () async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onRequestBack();
        });
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: ApplicationAppBarLarge(
          context,
          "back".tr,
          onBackPressed: () async {
            onRequestBack();
            return false;
          },
        ),
        body: Container(
          padding: const EdgeInsets.only(top: kToolbarHeight * 2.3),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF241E5B), Color(0xFF222E7C)],
              stops: [0.0, 0.3],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xffF1F1FA),
            ),
            child: Column(
              children: [
                Obx(
                  () => Expanded(
                    child:
                        controller.isLoading.value
                            ? Center(child: CircularProgressIndicator())
                            : SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Obx(
                                    () => CreditCardFormCustom(
                                      formKey: controller.formKey,
                                      obscureCvv: true,
                                      obscureNumber: false,
                                      cardNumber: controller.cardNumber.value,
                                      cvvCode: controller.cvvCode.value,
                                      isHolderNameVisible: true,
                                      isCardNumberVisible: true,
                                      isExpiryDateVisible: true,
                                      cardHolderName:
                                          controller.cardHolderName.value,
                                      expiryDate: controller.expiryDate.value,
                                      themeColor: GolfColor.GolfPrimaryColor,
                                      textColor: themeData.iconTheme.color!,
                                      cvvErrorText:
                                          controller.cvvErrorText.value,
                                      numberValidationMessage:
                                          "card_number_invalid".tr,
                                      dateValidationMessage:
                                          "expired_date_invalid".tr,
                                      cvvValidationMessage: "cvv_invalid".tr,
                                      cvvCodeKey: controller.cvvGlobalKey,
                                      cardNumberDecoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.all(8),
                                        hintStyle: GoogleFonts.inter(
                                          color: themeData.iconTheme.color,
                                        ),
                                        labelStyle: GoogleFonts.inter(
                                          color: themeData.iconTheme.color,
                                        ),
                                        labelText: 'card_number'.tr,
                                        hintText: 'card_number_hint'.tr,
                                        focusedBorder: border,
                                        enabledBorder: border,
                                      ),
                                      expiryDateDecoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.all(8),
                                        hintStyle: GoogleFonts.inter(
                                          color: themeData.iconTheme.color,
                                        ),
                                        labelStyle: GoogleFonts.inter(
                                          color: themeData.iconTheme.color,
                                        ),
                                        focusedBorder: border,
                                        enabledBorder: border,
                                        labelText: 'expired_date'.tr,
                                        hintText: 'expired_date_hint'.tr,
                                      ),
                                      cvvCodeDecoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.all(8),
                                        hintStyle: GoogleFonts.inter(
                                          color: themeData.iconTheme.color,
                                        ),
                                        labelStyle: GoogleFonts.inter(
                                          color: themeData.iconTheme.color,
                                        ),
                                        focusedBorder: border,
                                        enabledBorder: border,
                                        labelText: 'cvv'.tr,
                                        hintText: 'cvv_hint'.tr,
                                      ),
                                      cardHolderDecoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.all(8),
                                        hintStyle: GoogleFonts.inter(
                                          color: themeData.iconTheme.color,
                                        ),
                                        labelStyle: GoogleFonts.inter(
                                          color: themeData.iconTheme.color,
                                        ),
                                        focusedBorder: border,
                                        enabledBorder: border,
                                        labelText: 'card_holder'.tr,
                                        hintText: "TARO YAMADA",
                                      ),
                                      onCreditCardModelChange:
                                          controller.onCreditCardModelChange,
                                      cardNumberController:
                                          controller.cardNumberController,
                                      expiryDateController:
                                          controller.expiryDateController,
                                      cvvCodeController:
                                          controller.cvvCodeController,
                                      cardHolderNameController:
                                          controller.cardHolderNameController,
                                    ),
                                  ),
                                  // Checkbox đồng ý điều khoản
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Obx(
                                      () => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value:
                                                controller
                                                    .isAgreedToTerms
                                                    .value,
                                            onChanged: (value) {
                                              controller.isAgreedToTerms.value =
                                                  value ?? false;
                                            },
                                            activeColor:
                                                GolfColor.GolfPrimaryColor,
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                _showPaymentLawWebView(context);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 12.0,
                                                ),
                                                child: Text(
                                                  "i_agree_to_the_specified_commercial_transactions_law"
                                                      .tr,
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    decoration:
                                                        TextDecoration
                                                            .underline,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Obx(
                                      () => DefaultButton(
                                        radius: 10,
                                        text: 'payment'.tr,
                                        textColor: Colors.white,
                                        backgroundColor:
                                            controller.isAgreedToTerms.value
                                                ? Color(0xff08D586)
                                                : Colors.grey,
                                        press:
                                            controller.isAgreedToTerms.value
                                                ? () {
                                                  controller.onValidate();
                                                }
                                                : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentLawWebView(BuildContext context) {
    showDialog(
      context: context,
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GolfColor.GolfPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'back'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: WebViewWidget(
                    controller:
                        WebViewController()
                          ..setJavaScriptMode(JavaScriptMode.unrestricted)
                          ..loadRequest(
                            Uri.parse('https://mujin24.com/?p=paymentlaw'),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  onRequestBack() {
    SupportUtils.showDecisionDialog(
      'you_have_not_complete_the_payment'.tr,
      lstOptions: [
        DecisionOption(
          'yes'.tr,
          type: DecisionOptionType.DENIED,
          onDecisionPressed: () {
            Get.back(result: PageResult(resultCode: PageResultCode.FAIL));
          },
        ),
        DecisionOption(
          'continue_payment'.tr,
          onDecisionPressed: null,
          isImportant: true,
        ),
      ],
    );
  }
}
