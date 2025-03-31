import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/model/decision_option.dart';
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:golf_uiv2/utils/support.dart';
import 'package:golf_uiv2/widgets/application_appbar.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/page_result.dart';
import '../../services/golf_api.dart';
import '../../widgets/button_default.dart';
import 'credit_card_form_custom.dart';
import 'payment_new_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    final formKey = GlobalKey<FormState>();
    var border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );

    void _onValidate() async {
      if (formKey.currentState!.validate()) {
        var rs = await controller.getPaymentKey();
        if (rs != null) {
          var result = await Get.toNamed(AppRoutes.PYAYMENT_WEB, arguments: rs);
          if (result as bool) {
            var isSuccess = await GolfApi().cardMpiCheckResult(rs.oderId!);
            if (isSuccess.data ?? false) {
              Get.back(
                  result: PageResult(resultCode: PageResultCode.OK, data: rs));
            } else {
              Get.back(
                result: PageResult(resultCode: PageResultCode.FAIL),
              );
            }
          } else {
            Get.back(
              result: PageResult(resultCode: PageResultCode.FAIL),
            );
          }
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        onRequestBack();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: themeData.scaffoldBackgroundColor,
        appBar: ApplicationAppBar(context,
          "back".tr,
          onBackPressed: () async {
            onRequestBack();
            return false;
          },
        ),
        body: Container(
          child: Column(
            children: [
              Obx(
                () => Expanded(
                  child: controller.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              // CreditCardFormCustom(
                              //   formKey: formKey,
                              //   obscureCvv: true,
                              //   obscureNumber: false,
                              //   cardNumber: controller.cardNumber.value,
                              //   cvvCode: controller.cvvCode.value,
                              //   isHolderNameVisible: true,
                              //   isCardNumberVisible: true,
                              //   isExpiryDateVisible: true,
                              //   cardHolderName: controller.cardHolderName.value,
                              //   expiryDate: controller.expiryDate.value,
                              //   themeColor: GolfColor.GolfPrimaryColor,
                              //   textColor: themeData.iconTheme.color!,
                              //   cardNumberDecoration: InputDecoration(
                              //     hintStyle: GoogleFonts.openSans(
                              //         color: themeData.iconTheme.color),
                              //     labelStyle: GoogleFonts.openSans(
                              //         color: themeData.iconTheme.color),
                              //     labelText: 'Card Number',
                              //     hintText: 'XXXX XXXX XXXX XXXX',
                              //     focusedBorder: border,
                              //     enabledBorder: border,
                              //   ),
                              //   expiryDateDecoration: InputDecoration(
                              //     hintStyle: GoogleFonts.openSans(
                              //         color: themeData.iconTheme.color),
                              //     labelStyle: GoogleFonts.openSans(
                              //         color: themeData.iconTheme.color),
                              //     focusedBorder: border,
                              //     enabledBorder: border,
                              //     labelText: 'Expired Date',
                              //     hintText: 'XX/XX',
                              //   ),
                              //   cvvCodeDecoration: InputDecoration(
                              //     hintStyle: GoogleFonts.openSans(
                              //         color: themeData.iconTheme.color),
                              //     labelStyle: GoogleFonts.openSans(
                              //         color: themeData.iconTheme.color),
                              //     focusedBorder: border,
                              //     enabledBorder: border,
                              //     labelText: 'CVV',
                              //     hintText: 'XXX',
                              //   ),
                              //   cardHolderDecoration: InputDecoration(
                              //       hintStyle: GoogleFonts.openSans(
                              //           color: themeData.iconTheme.color),
                              //       labelStyle: GoogleFonts.openSans(
                              //           color: themeData.iconTheme.color),
                              //       focusedBorder: border,
                              //       enabledBorder: border,
                              //       labelText: 'Card Holder',
                              //       hintText: "XXX XXX XXX"),
                              //   onCreditCardModelChange:
                              //       controller.onCreditCardModelChange,
                              //   cardNumberController:
                              //       controller.cardNumberController,
                              //   expiryDateController:
                              //       controller.expiryDateController,
                              //   cvvCodeController: controller.cvvCodeController,
                              //   cardHolderNameController:
                              //       controller.cardHolderNameController,
                              // ),
                              const SizedBox(
                                height: 20,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: DefaultButton(
                                  text: 'payment'.tr,
                                  textColor: Colors.white,
                                  backgroundColor:
                                      themeData.colorScheme.primary,
                                  press: () {
                                    _onValidate();
                                  },
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
    );
  }

  onRequestBack() {
    SupportUtils.showDecisionDialog('you_have_not_complete_the_payment'.tr,
        lstOptions: [
          DecisionOption('yes'.tr, type: DecisionOptionType.DENIED,
              onDecisionPressed: () {
            Get.back();
          }),
          DecisionOption('continue_payment'.tr,
              onDecisionPressed: null, isImportant: true)
        ]);
  }
}
