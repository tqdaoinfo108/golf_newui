import 'package:flutter/material.dart';
import 'package:golf_uiv2/widgets/button_default.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

Widget buttonBookingWaitingPayment(ThemeData themeData,
    {Function? onCancelPressed,
    Function? onPaymentPressed,
    bool isEnablePayment = true}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Expanded(
        child: DefaultButton(
          text: 'cancel'.tr,
          textColor: Colors.white,
          backgroundColor: Colors.black87,
          press: onCancelPressed,
        ),
      ),
      SizedBox(width: 2.0.h),
      Expanded(
        child: AbsorbPointer(
          absorbing: !isEnablePayment,
          child: Opacity(
            opacity: isEnablePayment ? 1.0 : 0.2,
            child: DefaultButton(
              text: 'payment'.tr,
              textColor: themeData.colorScheme.onSecondary,
              backgroundColor: themeData.colorScheme.secondary,
              press: onPaymentPressed,
            ),
          ),
        ),
      )
    ],
  );
}

Widget buttonBookingPaid(ThemeData themeData,
    {Function? onCreateTicketPressed}) {
  return Row(
    children: [
      Expanded(
        child: DefaultButton(
          text: 'create_ticket'.tr,
          textColor: Colors.white,
          backgroundColor: Colors.green,
          press: onCreateTicketPressed,
        ),
      )
    ],
  );
}
