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
        resizeToAvoidBottomInset: true,
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
          padding: const EdgeInsets.only(top: kToolbarHeight * 1.8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF241E5B), Color(0xFF222E7C)],
              stops: [0.0, 0.3],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'payment_info_title'.tr,
                      style: GoogleFonts.openSans(
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'payment_info_subtitle'.tr,
                      style: GoogleFonts.openSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    color: Color(0xffF1F1FA),
                  ),
                  child: Obx(
                    () =>
                        controller.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : SingleChildScrollView(
                              padding: const EdgeInsets.only(
                                top: 14,
                                bottom: 24,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Obx(
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
                                          fillColor: Color(0xFFF2F3F8),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 10,
                                              ),
                                          hintStyle: GoogleFonts.inter(
                                            color: Color(0xFFA8ADC5),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          labelStyle: GoogleFonts.inter(
                                            color: Color(0xFF3B3F63),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                          labelText: 'card_number'.tr,
                                          hintText:
                                              'card_number_placeholder'.tr,
                                          focusedBorder: border,
                                          enabledBorder: border,
                                        ),
                                        expiryDateDecoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFFF2F3F8),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 10,
                                              ),
                                          hintStyle: GoogleFonts.inter(
                                            color: Color(0xFFA8ADC5),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          labelStyle: GoogleFonts.inter(
                                            color: Color(0xFF3B3F63),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                          focusedBorder: border,
                                          enabledBorder: border,
                                          labelText: 'expired_date'.tr,
                                          hintText:
                                              'expired_date_placeholder'.tr,
                                        ),
                                        cvvCodeDecoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFFF2F3F8),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 10,
                                              ),
                                          hintStyle: GoogleFonts.inter(
                                            color: Color(0xFFA8ADC5),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          labelStyle: GoogleFonts.inter(
                                            color: Color(0xFF3B3F63),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                          focusedBorder: border,
                                          enabledBorder: border,
                                          labelText: 'cvv'.tr,
                                          hintText: 'cvv_placeholder'.tr,
                                        ),
                                        cardHolderDecoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFFF2F3F8),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 10,
                                              ),
                                          hintStyle: GoogleFonts.inter(
                                            color: Color(0xFFA8ADC5),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          labelStyle: GoogleFonts.inter(
                                            color: Color(0xFF3B3F63),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                          focusedBorder: border,
                                          enabledBorder: border,
                                          labelText: 'card_holder'.tr,
                                          hintText:
                                              'card_holder_placeholder'.tr,
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
                                  ),
                                  const SizedBox(height: 12),
                                  _buildTotalAmountCard(controller.totalAmount),
                                  const SizedBox(height: 12),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Obx(
                                      () => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 28,
                                            height: 28,
                                            child: Transform.scale(
                                              scale: 1.15,
                                              child: Checkbox(
                                                value:
                                                    controller
                                                        .isAgreedToTerms
                                                        .value,
                                                onChanged: (value) {
                                                  controller
                                                      .isAgreedToTerms
                                                      .value = value ?? false;
                                                },
                                                activeColor:
                                                    GolfColor.GolfPrimaryColor,
                                                side: const BorderSide(
                                                  color: Color(0xFFBFC3D9),
                                                ),
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                _showPaymentLawWebView(context);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 2,
                                                ),
                                                child: Text(
                                                  "i_agree_to_the_specified_commercial_transactions_law"
                                                      .tr,
                                                  style: GoogleFonts.inter(
                                                    color: Color(0xFF2D8DFD),
                                                    decoration:
                                                        TextDecoration
                                                            .underline,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
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
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Obx(
                                      () => DefaultButton(
                                        radius: 12,
                                        height: 50,
                                        text: 'payment'.tr,
                                        textColor: Colors.white,
                                        backgroundColor:
                                            controller.isAgreedToTerms.value
                                                ? Color(0xFF08D586)
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.lock,
                                        size: 14,
                                        color: Color(0xFFB0B4CF),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'payment_secure_notice'.tr,
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFFB0B4CF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalAmountCard(int totalAmount) {
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE4E5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDCE0F5), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2460).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'total_amount'.tr,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF3B3F63),
              fontWeight: FontWeight.w700,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '¥$totalAmount',
                  style: GoogleFonts.inter(
                    fontSize: 46,
                    color: const Color(0xFF2F3F95),
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: ' (税込)',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF8B90B9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
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
      'leave_waiting_payment_warning'.tr,
      lstOptions: [
       
        DecisionOption(
          'continue_booking'.tr,
          onDecisionPressed: null,
          isImportant: true,
        ),
         DecisionOption(
          'back'.tr,
          type: DecisionOptionType.DENIED,
          onDecisionPressed: () {
            Get.back(result: PageResult(resultCode: PageResultCode.FAIL));
          },
        ),
      ],
    );
  }
}
