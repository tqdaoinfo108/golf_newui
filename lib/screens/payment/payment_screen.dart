// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:golf_uiv2/model/decision_option.dart';
// import 'package:golf_uiv2/model/page_result.dart';
// import 'package:golf_uiv2/screens/payment/payment_controller.dart';
// import 'package:golf_uiv2/themes/colors_custom.dart';
// import 'package:golf_uiv2/utils/color.dart';
// import 'package:golf_uiv2/utils/support.dart';
// import 'package:golf_uiv2/widgets/application_appbar.dart';
// import 'package:sizer/sizer.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:golf_uiv2/utils/constants.dart';

// class PaymentScreen extends GetView<PaymentController> {
//   PaymentScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (Platform.isAndroid) {
//       WebView.platform = SurfaceAndroidWebView();
//     } // <<== THIS
//     ThemeData themeData = Theme.of(context);
//     final webviewLoading = true.obs;

//     return WillPopScope(
//       onWillPop: () async {
//         onRequestBack();
//         return false;
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: GolfColor.GolfPrimaryColor,
//         appBar: ApplicationAppBar(context,
//           "back".tr,
//           onBackPressed: () async {
//             onRequestBack();
//             return false;
//           },
//         ),
//         body: Container(
//           child: Column(
//             children: [
//               Expanded(
//                 child: Container(
//                   padding: EdgeInsets.only(bottom: 2.0.h),
//                   height: double.infinity, // <-----
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(6.0.w),
//                         topRight: Radius.circular(6.0.w)),
//                     color: themeData.colorScheme.backgroundCardColor,
//                   ),
//                   child: controller.obx(
//                     (paymentResponse) => Stack(
//                       children: [
//                         WebView(
//                           javascriptMode: JavascriptMode.unrestricted,
//                           initialUrl: Uri.dataFromString(
//                             buildPaymentPage(
//                               PAYMENT_POP_SCRIPT_URL,
//                               paymentResponse!.clientKey,
//                               paymentResponse.paymentKey,
//                             ),
//                             mimeType: 'text/html',
//                           ).toString(),
//                           gestureNavigationEnabled: true,
//                           onPageStarted: (_url) {
//                             webviewLoading.value = true;
//                             if (_url == PAYMENT_SUCCESS_URL) {
//                               Get.back(
//                                 result: PageResult(
//                                   resultCode: PageResultCode.OK,
//                                   data: paymentResponse,
//                                 ),
//                               );
//                             } else if (_url == PAYMENT_FAILURE_URL) {
//                               Get.back(
//                                 result:
//                                     PageResult(resultCode: PageResultCode.FAIL),
//                               );
//                             }
//                           },
//                           onPageFinished: (_url) {
//                             webviewLoading.value = false;
//                           },
//                         ),
//                         Obx(() => webviewLoading.value
//                             ? _buildLoadingIndicator(themeData)
//                             : Container()),
//                       ],
//                     ),
//                     onLoading: _buildLoadingIndicator(themeData),
//                     onError: (error) {
//                       SupportUtils.showToast(error, type: ToastType.ERROR);
//                       return Container();
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingIndicator(ThemeData appTheme) => Container(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       );

//   String buildPaymentPage(
//       String popScriptUrl, String? popClientKey, String? paymentKey) {
//     final language = Get.locale.toString().contains("en") ? "en" : "ja";

//     return "<!DOCTYPE html> <html> <head> <meta charset=\"UTF-8\" /> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" /> <script type=\"text/javascript\" src=\"$popScriptUrl\" data-client-key=\"$popClientKey\"></script> <script type=\"text/javascript\"> function letsPayment() { pop.pay(\"$paymentKey\", { language: \"$language\" }); } </script> </head> <body onload=\"letsPayment();\" /> </html> ";
//   }

//   onRequestBack() {
//     SupportUtils.showDecisionDialog('you_have_not_complete_the_payment'.tr,
//         lstOptions: [
//           DecisionOption('yes'.tr, type: DecisionOptionType.DENIED,
//               onDecisionPressed: () {
//             Get.back();
//           }),
//           DecisionOption('continue_payment'.tr,
//               onDecisionPressed: null, isImportant: true)
//         ]);
//   }
// }
