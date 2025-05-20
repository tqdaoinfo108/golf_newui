import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/screens/payment_new_web/payment_new_web_controller.dart';
import 'package:golf_uiv2/themes/colors_custom.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../model/decision_option.dart';
import '../../utils/color.dart';
import '../../utils/constants.dart';
import '../../utils/support.dart';
import '../../widgets/application_appbar.dart';

class PaymentWebScreen extends GetView<PaymentWebController> {
  onRequestBack() {
    SupportUtils.showDecisionDialog('you_have_not_complete_the_payment'.tr,
        lstOptions: [
          DecisionOption('yes'.tr, type: DecisionOptionType.DENIED,
              onDecisionPressed: () {
          }),
          DecisionOption('continue_payment'.tr,
              onDecisionPressed: null, isImportant: true)
        ]);
  }

  @override
  Widget build(BuildContext context) {

    ThemeData themeData = Theme.of(context);
    final webviewLoading = true.obs;
    var controllerWeb = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            webviewLoading.value = false;
            if (url == controller.arg.reqRedirectionUri) {
              Get.back(result: true);
            }
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadHtmlString(controller.arg.resResponseContents!);
    return WillPopScope(
      onWillPop: () async {
        onRequestBack();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: GolfColor.GolfPrimaryColor,
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
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 2.0.h),
                  height: double.infinity, // <-----
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6.0.w),
                        topRight: Radius.circular(6.0.w)),
                    color: themeData.colorScheme.backgroundCardColor,
                  ),
                  child: WebViewWidget(controller: controllerWeb)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
