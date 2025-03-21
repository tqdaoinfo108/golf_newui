import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:golf_uiv2/widgets/button_default.dart';
import 'package:sizer/sizer.dart';

class ButtonUnavailablePayment extends StatelessWidget {
  const ButtonUnavailablePayment({Key? key, this.onCancelPressed})
      : super(key: key);

  final void Function()? onCancelPressed;

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
            backgroundColor: Colors.black87,
            press: onCancelPressed,
          ),
        ),
        SizedBox(width: 2.0.h),
        Expanded(
          child: Opacity(
            opacity: 0.2,
            child: DefaultButton(
              text: 'payment'.tr,
              textColor: appTheme.colorScheme.onSecondary,
              backgroundColor: appTheme.colorScheme.secondary,
            ),
          ),
        )
      ],
    );
  }
}
