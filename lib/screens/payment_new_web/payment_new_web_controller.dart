import 'package:get/get.dart';
import 'package:golf_uiv2/utils/support.dart';

import '../../model/payment_key_response.dart';

class PaymentWebdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentWebController>(() => PaymentWebController());
  }
}

class PaymentWebController extends GetxController {
  late PaymentKeyResponse arg;
  @override
  void onInit() {
    super.onInit();
    arg = Get.arguments;

    if (arg.resResponseContents == null ||
        arg.resResponseContents!.isNullEmptyOrWhitespace ||
        arg.mstatus == "failure") {
      Get.back(result: false);
    }
  }
}
