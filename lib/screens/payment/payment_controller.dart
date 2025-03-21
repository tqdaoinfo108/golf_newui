// import 'package:get/get.dart';
// import 'package:golf_uiv2/model/application_error.dart';
// import 'package:golf_uiv2/model/auth.dart';
// import 'package:golf_uiv2/model/auth_body.dart';
// import 'package:golf_uiv2/model/get_payment_key_request.dart';
// import 'package:golf_uiv2/model/payment_key_response.dart';
// import 'package:golf_uiv2/services/golf_api.dart';
// import 'package:golf_uiv2/utils/constants.dart';

// class PaymentdBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<PaymentController>(() => PaymentController());
//   }
// }

// class PaymentController extends GetxController
//     with StateMixin<PaymentKeyResponse> {
//   GetPaymentKeyRequest? _paymentRequest;

//   @override
//   void onInit() {
//     super.onInit();
//     _paymentRequest = Get.arguments;

//     change(null, status: RxStatus.loading());
//     getPaymentKey();
//   }

//   Future<void> getPaymentKey() async {
//     /// Call Service
//     final _result =
//         await GolfApi().getPaymentKey(AuthBody<Map<String, dynamic>>()
//           ..setAuth(Auth())
//           ..setData(_paymentRequest!.toJson(), dataToJson: (data) => data));

//     /// Handle result
//     if (_result.data != null) {
//       change(_result.data, status: RxStatus.success());
//     } else {
//       if (_result.getExcept+ion == null) {
//         _result.setException(ApplicationError.withCode(
//             ApplicationErrorCode.UNKNOW_APPLICATION_ERROR));
//       }

//       change(_result.data,
//           status: RxStatus.error(_result.getException!.getErrorMessage()));
//     }
//   }
// }
