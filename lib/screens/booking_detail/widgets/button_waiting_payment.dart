import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:golf_uiv2/widgets/button_default.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/color.dart';

class ButtonWatingPayment extends StatelessWidget {
  const ButtonWatingPayment(
      {Key? key, this.onCancelPressed, this.onPaymentPressed})
      : super(key: key);

  final void Function()? onCancelPressed;
  final void Function()? onPaymentPressed;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: DefaultButton(
            text: 'cancel_booking'.tr,
            textColor: Colors.white,
            radius: 12,
            backgroundColor: Color(0xff4053BF),
            press: onCancelPressed,
          ),
        ),
        SizedBox(width: 2.0.h),
        Expanded(
          child: DefaultButton(
            text: 'payment'.tr,
            textColor: appTheme.colorScheme.onSecondary,
            backgroundColor: GolfColor.GolfPrimaryColor,
            radius: 12,
            press: onPaymentPressed,
          ),
        )
      ],
    );
  }
}
